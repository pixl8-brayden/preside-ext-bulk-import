component {
	property name="objectDirectories"   inject="presidecms:directories:preside-objects";
	property name="presideObjectReader" inject="PresideObjectReader";

	public string function index( event, rc, prc, args={} ) {

		if ( !objectDirectories.len() ) {
			return "";
		}

		var objects = [];
		objects.append( "website_user" );

		args.values = [ "" ];
		args.labels = [ "" ];

		// objects = presideObjectReader.readObjects( _getAllObjectPaths( objectDirectories ) );

		for ( object in objects ) {
			args.values.append( object );
			args.labels.append( ucFirst( replace( object, "_", " ", "ALL" ) ) );
		}

		return renderView( view="formcontrols/select/index", args=args );
	}

	private array function _getAllObjectPaths( required array objectDirectories ) {
		var dirs        = arguments.objectDirectories;
		var dir         = "";
		var dirExpanded = "";
		var files       = "";
		var file        = "";
		var paths       = [];
		var path        = "";
		for( dir in dirs ) {
			files = DirectoryList( path=dir, recurse=true, filter="*.cfc" );
			dirExpanded = ExpandPath( dir );

			for( file in files ) {
				path = dir & Replace( file, dirExpanded, "" );
				path = ListDeleteAt( path, ListLen( path, "." ), "." );
				path = ListChangeDelims( path, "/", "\" );

				ArrayAppend( paths, path );
			}
		}

		return paths;
	}
}