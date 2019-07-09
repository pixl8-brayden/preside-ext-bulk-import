<cfscript>
	if ( isFeatureEnabled( "bulkimport" ) ) {
		writeOutput( renderView(
			  view = "/admin/layout/sidebar/_menuItem"
			, args = {
				  active  = ListLast( event.getCurrentHandler(), ".") eq "bulkimport"
				, link    = event.buildAdminLink( linkTo="bulkimport" )
				, gotoKey = "i"
				, icon    = "fa-cloud-upload"
				, title   = translateResource( 'bulkimport:admin.menu.title' )
			  }
		) );
	}
</cfscript>