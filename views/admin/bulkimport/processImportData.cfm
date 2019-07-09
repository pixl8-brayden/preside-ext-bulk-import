<cfoutput>

<div class="row">
	<div class="col-md-12">
		<cfif prc.success ?: false>
			<h1 class="header green lighter">Successful Import Data into #replace( rc.objects ?: "", "_", " ", "ALL" )#</h1>
		<cfelse>
			<h1 class="header red lighter">Something went wrong. Please check and import again.</h1>
		</cfif>
	</div>
</div>

<div class="row">
	<div class="col-md-2">
		<a type="submit" class="btn btn-secondary" tabindex="#getNextTabIndex()#" href="#event.buildAdminLink( linkTo='bulkimport.index' )#">
			<i class="fa fa-chevron-left bigger-110"></i> #translateResource( uri="bulkimport:back.btn" )#
		</a>
	</div>
</div>

</cfoutput>