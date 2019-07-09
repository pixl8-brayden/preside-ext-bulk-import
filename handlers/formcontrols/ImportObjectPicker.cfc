component {
	property name="objectDirectories"   inject="presidecms:directories:preside-objects";
	property name="presideObjectReader" inject="PresideObjectReader";

	public string function index( event, rc, prc, args={} ) {

		if ( !objectDirectories.len() ) {
			return "";
		}

		var objects = [];
		var removed = [
			  'email_mass_send_queue'
			, 'log_entry'
			, 'preside_database_version'
			, 'taskmanager_adhoc_task'
			, 'standard_page'
			, 'security_user'
			, 'taskmanager_task_history'
			, 'audit_log'
			, 'rules_engine_condition'
			, 'asset_meta'
			, 'homepage'
			, 'email_template_view_online_content'
			, 'admin_notification_consumer'
			, 'website_benefit_combined_benefits'
			, 'security_user_login_token'
			, 'email_blueprint'
			, 'asset_storage_location'
			, 'url_redirect_rule'
			, 'taskmanager_task'
			, 'admin_notification_subscription'
			, 'formbuilder_formsubmission'
			, 'formbuilder_formitem'
			, 'system_config'
			, 'formbuilder_formaction'
			, 'reset_password'
			, 'asset_version'
			, 'email_template'
			, 'notFound'
			, 'workflow_state'
			, 'site'
			, 'website_user_action'
			, 'website_benefit'
			, 'asset_folder'
			, 'forgotten_password'
			, 'security_user_two_factor_login_record'
			, 'email_template_send_log_activity'
			, 'asset'
			, 'site_redirect_domain'
			, 'email_layout_config_item'
			, 'security_group'
			, 'admin_notification_topic'
			, 'accessDenied'
			, 'login'
			, 'password_policy'
			, 'site_alias_domain'
			, 'admin_notification'
			, 'website_user_login_token'
			, 'formbuilder_form'
			, 'website_applied_permission'
			, 'link'
			, 'asset_derivative'
			, 'security_context_permission'
			, 'email_template_send_log'
		];

		args.values = [ "" ];
		args.labels = [ "" ];

		objects = presideObjectReader.readObjects( _getAllObjectPaths( objectDirectories ) );

		for ( object in objects ) {
			if ( !arrayContains( removed, object ) ) {
				args.values.append( object );
				args.labels.append( ucFirst( replace( object, "_", " ", "ALL" ) ) );
			}
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