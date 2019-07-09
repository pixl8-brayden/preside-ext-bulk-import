<cfscript>
	formId       = "bulk-import";
	formAction   = event.buildAdminLink( linkto="bulkimport.import" );
	site         = rc.site ?: "";
	isSiteConfig = Len( Trim( site ) );
	savedData    = prc.savedData ?: {};
	sites        = prc.sites ?: QueryNew('');
</cfscript>

<cfoutput>
	<form id="#formId#" data-auto-focus-form="true" data-dirty-form="protect" class="form-horizontal edit-object-form" method="post" action="#formAction#">
		<cfif isSiteConfig>
			<input name="site" type="hidden" value="#site#">
		</cfif>

		#renderForm(
			  formName          = "admin.importOptionForm"
			, context           = "admin"
			, formId            = formId
			, savedData         = rc.formData ?: {}
			, validationResult  = rc.validationResult ?: ""
			, fieldLayout       = isSiteConfig ? "formcontrols.layouts.fieldWithOverrideOption"    : NullValue()
			, fieldsetLayout    = isSiteConfig ? "formcontrols.layouts.fieldsetWithOverrideOption" : NullValue()
		)#

		<div class="form-actions row">
			<div class="col-md-offset-2">
				<button type="submit" class="btn btn-info" tabindex="#getNextTabIndex()#">
					<i class="fa fa-cloud-upload bigger-110"></i> #translateResource( uri="bulkimport:import.btn" )#
				</button>
			</div>
		</div>
	</form>
</cfoutput>