(function($) {
	/***
	 * A sample AJAX data store implementation.
	 */
	function RemoteModel() {
		// private
		var PAGESIZE = 5;
		var data = {length:0};
		var searchstr = "";
		var sortcol = null;
		var sortdir = 1;
		var h_request = null;
		var req = null; // ajax request

		// events
		var onDataLoading = new Slick.Event();
		var onDataLoaded = new Slick.Event();


		function init() {
		}


		function isDataLoaded(from,to) {
			for (var i=from; i<=to; i++) {
				if (data[i] == undefined || data[i] == null)
					return false;
			}

			return true;
		}


		function clear() {
			for (var key in data) {
				delete data[key];
			}
			data.length = 0;
		}


		function ensureData(from,to) {
			if (req) {
				req.abort();
				for (var i=req.fromPage; i<=req.toPage; i++)
					data[i*PAGESIZE] = undefined;
			}

			if (from < 0)
				from = 0;

			var fromPage = Math.floor(from / PAGESIZE);
			var toPage = Math.floor(to / PAGESIZE);

			while (data[fromPage * PAGESIZE] !== undefined && fromPage < toPage)
				fromPage++;

			while (data[toPage * PAGESIZE] !== undefined && fromPage < toPage)
				toPage--;

			if (fromPage > toPage || ((fromPage == toPage) && data[fromPage*PAGESIZE] !== undefined)) {
				// TODO:  look-ahead
				return;
			}


			if (h_request != null)
				clearTimeout(h_request);
			h_request = setTimeout(function() {
				for (var i=fromPage; i<=toPage; i++)
					data[i*PAGESIZE] = null; // null indicates a 'requested but not available yet'
				onDataLoading.notify({from:from, to:to});

				req = $.ajax({
					url: url + "&filter=" + filter + "&offset=" + (fromPage * PAGESIZE + 1) + "&max=" + (((toPage - fromPage) * PAGESIZE) + PAGESIZE),
					cache: true, 
					success: onSuccess,
					error: function(){
						onError(fromPage, toPage)
					}
					});
				req.fromPage = fromPage;
				req.toPage = toPage;
			}, 50);
		}


		function onError(fromPage,toPage) {
			console.log("error loading pages " + fromPage + " to " + toPage);
		}

		function onSuccess(resp) {
			console.log("record size: " + eval("resp.data." + objectName + ".length"));
			var from = req.fromPage*PAGESIZE, to = from + eval("resp.data." + objectName + ".length");
			data.length = parseInt(eval("resp.data.total"));
			

			for (var i = 0; i < eval("resp.data." + objectName + ".length"); i++) {
				console.log(eval("resp.data." + objectName + "[" + i + "]"));
				data[from + i] = eval("resp.data." + objectName + "[" + i + "]");
				data[from + i].index = from + i;
				data[from + i].edit = '<img src="/resources/images/icons/page_edit.png" onclick="location.href=\'/' + objectName + '/show/' + eval("resp.data." + objectName + "[" + i + "]." + keyField) + '\';" />';
				data[from + i].delete = '<img src="/resources/images/icons/page_delete.png" onclick="if(confirm(\'Are you sure?\')){location.href=\'/' + objectName + '/delete/' + eval("resp.data." + objectName + "[" + i + "]." + keyField) + '\';}" />';
			}

			req = null;

			onDataLoaded.notify({from:from, to:to});
		}


		function reloadData(from,to) {
			for (var i=from; i<=to; i++)
				delete data[i];

			ensureData(from,to);
		}


		function setSort(column,dir) {
			sortcol = column;
			sortdir = dir;
			clear();
		}

		function setSearch(str) {
			searchstr = str;
			clear();
		}


		init();

		return {
			// properties
			"data": data,

			// methods
			"clear": clear,
			"isDataLoaded": isDataLoaded,
			"ensureData": ensureData,
			"reloadData": reloadData,
			"setSort": setSort,
			"setSearch": setSearch,

			// events
			"onDataLoading": onDataLoading,
			"onDataLoaded": onDataLoaded
		};
	}

	// Slick.Data.RemoteModel
	$.extend(true, window, { Slick: { Data: { RemoteModel: RemoteModel }}});
})(jQuery);