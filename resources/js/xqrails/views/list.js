var grid;
var data = [];
var loader;

var options = {
	editable : false,
	enableAddRow : false,
	enableCellNavigation : false,
	asyncEditorLoading : false,
	autoEdit : false
};
function myFilter(item, args) {
	if (item["percentComplete"] < args.percentCompleteThreshold)
		return false;

	if (args.searchString != ""
			&& item["title"].indexOf(args.searchString) == -1)
		return false;

	return true;
}
function toggleFilterRow() {
	if ($(grid.getTopPanel()).is(":visible"))
		grid.hideTopPanel();
	else
		grid.showTopPanel();
}
$(".grid-header .ui-icon").addClass("ui-state-default ui-corner-all")
		.mouseover(function(e) {
			$(e.target).addClass("ui-state-hover")
		}).mouseout(function(e) {
			$(e.target).removeClass("ui-state-hover")
		});

var loadingIndicator = null;

$(function() {
	loader = new Slick.Data.RemoteModel();
	grid = new Slick.Grid("#myGrid", loader.data, columns, options);


	grid.onViewportChanged.subscribe(function(e, args) {
		var vp = grid.getViewport();
		loader.ensureData(vp.top, vp.bottom);
	});

	grid.onSort.subscribe(function(e, args) {
		loader.setSort(args.sortCol.field, args.sortAsc ? 1 : -1);
		var vp = grid.getViewport();
		loader.ensureData(vp.top, vp.bottom);
	});
	
	grid.onClick.subscribe(function(e, args) {
		console.log("event:");
		console.log(e);
		console.log("args:");
		console.log(args);
	});

	loader.onDataLoading.subscribe(function() {
				if (!loadingIndicator) {
					loadingIndicator = $(
							"<span class='loading-indicator'><label>Buffering...</label></span>")
							.appendTo(document.body);
					var $g = $("#myGrid");

					loadingIndicator.css("position", "absolute").css(
							"top",
							$g.position().top + $g.height() / 2
									- loadingIndicator.height() / 2).css(
							"left",
							$g.position().left + $g.width() / 2
									- loadingIndicator.width() / 2)
				}

				loadingIndicator.show();
			});

	loader.onDataLoaded.subscribe(function(e, args) {
		for ( var i = args.from; i <= args.to; i++) {
			grid.invalidateRow(i);
		}
		
		console.log("loading more...");

		grid.updateRowCount();
		grid.render();

		loadingIndicator.fadeOut();
	});


	// load the first page
	grid.onViewportChanged.notify();
});