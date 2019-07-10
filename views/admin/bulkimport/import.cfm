<cfoutput>

<div class="row">
	<div class="col-md-2">
		<a type="submit" class="btn btn-secondary" tabindex="#getNextTabIndex()#" href="#event.buildAdminLink( linkTo='bulkimport.index' )#">
			<i class="fa fa-chevron-left bigger-110"></i> #translateResource( uri="bulkimport:back.btn" )#
		</a>
	</div>
</div>

<div class="row">
	<div class="col-md-8">
		<h3 class="header smaller lighter green">Import #replace( rc.objects, "_", " ", "ALL" )#</h3>
		<form id="import-form" data-auto-focus-form="true" data-dirty-form="protect" class="form-horizontal" method="post" action="#event.buildAdminLink( linkto="bulkimport.processImportData" )#">

			<cfloop index="field" array=#prc.importObjectColumns#>
				#renderFormControl(
					  name     = field[ "fieldName" ]
					, id       = field[ "fieldName" ]
					, type     = "textInput"
					, label    = ucFirst( replace( field[ "fieldName" ], "_", " ", "ALL" ) )
					, required = field[ "required" ]
				)#
			</cfloop>

			#renderFormControl( name="objects", id="objects", type="hidden", defaultValue=( rc.objects ?: "" ), layout="formcontrols.layouts.hiddenField" )#
			#renderFormControl( name="file"   , id="file"   , type="hidden", defaultValue=( rc.file    ?: "" ), layout="formcontrols.layouts.hiddenField" )#

			<div class="form-actions row">
				<div class="col-md-offset-2">
					<button type="submit" class="btn btn-info" tabindex="#getNextTabIndex()#">
						<i class="fa fa-cloud-upload bigger-110"></i> #translateResource( uri="bulkimport:import.btn" )#
					</button>
				</div>
			</div>
		</form>
	</div>

	<div class="col-md-4" style="position: -webkit-sticky; position: sticky; top: 0;">
		<h3 class="header smaller lighter green text-right">File's Column</h3>
		<ul class="list-inline">
			<cfloop index="column" array="#prc.fileColumn#">
				<li style="margin-bottom: 10px; -webkit-user-select: all; -moz-user-select: all; -ms-user-select: all; user-select: all;" draggable="true"><code>{#column#}</code></li>
			</cfloop>
		</ul>
	</div>
</div>

</cfoutput>