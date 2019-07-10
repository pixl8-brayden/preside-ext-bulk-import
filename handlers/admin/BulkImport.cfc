component extends="preside.system.base.AdminHandler" {

	property name="presideObjectService" inject="PresideObjectService";
	property name="spreadsheetLib"       inject="spreadsheetLib";

	public function init() {
		return this;
	}

	function prehandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );
		_checkPermissions( event=event, key="navigate" );

		event.addAdminBreadCrumb(
			  title = translateResource( "bulkimport:admin.page.title"  )
			, link  = event.buildAdminLink( linkTo="bulkimport.index" )
		);
	}

	public void function index( event, rc, prc ) {
		prc.pageTitle           = translateResource( "bulkimport:admin.page.title"    );
		prc.pageSubTitle        = translateResource( "bulkimport:admin.page.subtitle" );
		prc.pageIcon            = "fa-cloud-upload";
	}

	public void function import( event, rc, prc ) {
		prc.pageTitle           = translateResource( "bulkimport:admin.page.title"    );
		if ( !isEmpty( rc.objects ?: "" ) ) {
			prc.pageSubTitle = translateResource( "bulkimport:admin.page.#rc.objects#" );
		} else {
			rc.objects = translateResource( "bulkimport:admin.page.title" );
		}
		prc.pageIcon            = "fa-cloud-upload";

		var formData         = event.getCollectionForForm();
		var validationResult = validateForms();
		var persistStruct    = {};

		if ( !validationResult.validated() ) {
			// TODO validation fail action
			persistStruct.formData = formData;
			setNextEvent(
				  url           = event.buildAdminLink(
					linkTo="bulkimport.index"
				)
				, persistStruct = persistStruct
			);
		}
		persistStruct.formData = formData;

		// get object field
		var importObject        = queryColumnArray( presideObjectService.getObject( rc.objects ).selectData() );
		prc.importObjectColumns = [];
		for ( data in importObject ) {
			if ( left(data, 1) NEQ '_' ) {
				switch( data ) {
				case "datecreated":
					break;
				case "datemodified":
					break;
				case "id":
					break;
				default:
					prc.importObjectColumns.append(data);
					break;
				}
			}
		}

		// get file columns
		var uploadedFile = presideObjectService.selectData(
			  objectName   = "asset"
			, selectFields = [
				'storage_path'
			]
			, id           = rc.file
		)

		if ( uploadedFile.recordcount ) {
			path           = ExpandPath('./') & 'uploads/assets' & uploadedFile.storage_path;
			var fileData   = spreadsheetLib.csvToQuery( filepath=path, firstRowIsHeader=true );
			prc.fileColumn = queryColumnArray( fileData );
		}

		event.addAdminBreadCrumb(
			  title = translateResource( "bulkimport:admin.page.#rc.objects#"  )
			, link  = event.buildAdminLink( linkTo="bulkimport.import" )
		);
	}

	public void function processImportData( event, rc, prc ) {
		prc.pageTitle    = translateResource( "bulkimport:admin.page.processImportData" );
		if ( !isEmpty( rc.objects ?: "" ) ) {
			prc.pageSubTitle = translateResource( "bulkimport:admin.page.#rc.objects#" );
		} else {
			rc.objects = translateResource( "bulkimport:admin.page.title" );
		}
		prc.pageIcon     = "fa-cloud-upload";

		if ( isEmpty( rc.file ?: "" ) ) {
			setNextEvent( url = event.buildAdminLink( linkTo="bulkimport.index" ) );
		}

		var fields     = listToArray( rc.fieldnames ?: "" );
		var fieldsData = {};

		for ( field in fields ) {
			if ( !isEmpty( rc[ field ] ) ) {
				var temp = rc[ field ];
				temp = left ( temp, temp.len()-1 );
				temp = right( temp, temp.len()-1 );
				fieldsData[ field ] = temp;
			}
		}
		structDelete( fieldsData, 'file'    );
		structDelete( fieldsData, 'objects' );

		// get file columns
		var uploadedFile = presideObjectService.selectData(
			  objectName   = "asset"
			, selectFields = [
				'storage_path'
			]
			, id           = rc.file
		)

		if ( uploadedFile.recordcount ) {
			path           = ExpandPath('./') & 'uploads/assets' & uploadedFile.storage_path;
			var fileData   = spreadsheetLib.csvToQuery( filepath=path, firstRowIsHeader=true );

			for ( row in fileData ) {
				var insertData = {};

				for ( field in fieldsData ) {
					insertData[ field ] = row[ fieldsData[field] ];
				}
				try {
					var dataInserted = presideObjectService.insertData(
						  objectName = rc.objects
						, data       = insertData
					)
				} catch(any exception){
					// skip import current record
				}
			}
			if ( !isEmpty( dataInserted ?: "" ) ) {
				prc.success = true;
			}
		}

		event.addAdminBreadCrumb(
			  title = translateResource( "bulkimport:admin.page.processImportData"  )
			, link  = event.buildAdminLink( linkTo="bulkimport.processImportData" )
		);
	}

// private helper
	private void function _checkPermissions( required any event, required string key ) {
		var permitted = true;
		var context   = "bulkimport"
		var permKey   = context & "." & arguments.key;

		permitted = hasCmsPermission( permissionKey=permKey, context=context );

		if ( !permitted ) {
			event.adminAccessDenied();
		}
	}

}