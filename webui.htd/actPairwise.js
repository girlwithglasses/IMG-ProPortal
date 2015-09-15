var foo = function() {
	YAHOO.example.ReorderRows = function() {
		rowNumbering = function(elCell, oRecord, oColumn) {
			var i = this.getRecordIndex(oRecord) + 1;
			var t = "<input type='text' size='4' readonly='readonly' name='order' value='"
					+ i + "'>"
			elCell.innerHTML = t;
		};
		YAHOO.widget.DataTable.Formatter.myCustom = rowNumbering;

		var Dom = YAHOO.util.Dom, Event = YAHOO.util.Event, DDM = YAHOO.util.DragDropMgr, myColumnDefs = [
				{
					key : "order",
					label : "Order",
					sortable : false,
					formatter : "myCustom"
				}, {
					key : "genome_id",
					label : "Genome Id",
					sortable : true,
					formatter : "Textbox"
				}, {
					key : "genome_name",
					label : "Genome Name",
					sortable : true
				} ], myDataSource = new YAHOO.util.LocalDataSource(
				YAHOO.example.genomes, {
					responseSchema : {
						fields : [ "genome_id", "genome_name" ]
					}
				}), myDataTable = new YAHOO.widget.DataTable("datatable",
				myColumnDefs, myDataSource, {
					caption : "YUI Datatable/DragDrop",
					paginator : new YAHOO.widget.Paginator( {
						rowsPerPage : 5000,
						alwaysVisible : false
					}),
					width : "90%",
					draggableColumns : false
				}), dragger = myDataTable;
		myDTDrags = {};

		// ////////////////////////////////////////////////////////////////////////////
		// Custom drag and drop class
		// ////////////////////////////////////////////////////////////////////////////
		YAHOO.example.DDRows = function(id, sGroup, config) {
			YAHOO.example.DDRows.superclass.constructor.call(this, id, sGroup,
					config);
			Dom.addClass(this.getDragEl(), "custom-class");
			this.goingUp = false;
			this.lastY = 0;
		};

		// ////////////////////////////////////////////////////////////////////////////
		// DDRows extends DDProxy
		// ////////////////////////////////////////////////////////////////////////////
		YAHOO
				.extend(
						YAHOO.example.DDRows,
						YAHOO.util.DDProxy,
						{
							proxyEl : null,
							srcEl : null,
							srcData : null,
							srcIndex : null,
							tmpIndex : null,

							startDrag : function(x, y) {
								var proxyEl = this.proxyEl = this.getDragEl(), srcEl = this.srcEl = this
										.getEl();

								this.srcData = myDataTable
										.getRecord(this.srcEl).getData();
								this.srcIndex = srcEl.sectionRowIndex;
								// Make the proxy look like the
								// source element
								Dom.setStyle(srcEl, "visibility", "hidden");
								proxyEl.innerHTML = "<table><tbody>"
										+ srcEl.innerHTML + "</tbody></table>";
							},

							endDrag : function(x, y) {
								var position, srcEl = this.srcEl;

								Dom.setStyle(this.proxyEl, "visibility",
										"hidden");
								Dom.setStyle(srcEl, "visibility", "");
							},

							onDrag : function(e) {
								// Keep track of the direction of the drag for use during onDragOver
							var y = Event.getPageY(e);

							if (y < this.lastY) {
								this.goingUp = true;
							} else if (y > this.lastY) {
								this.goingUp = false;
							}

							this.lastY = y;
						},

						onDragOver : function(e, id) {
							// Reorder rows as user drags
							var srcIndex = this.srcIndex, destEl = Dom.get(id), destIndex = destEl.sectionRowIndex, tmpIndex = this.tmpIndex;

							if (destEl.nodeName.toLowerCase() === "tr") {
								if (tmpIndex !== null) {
									myDataTable.deleteRow(tmpIndex);
								} else {
									myDataTable.deleteRow(this.srcIndex);
								}

								myDataTable.addRow(this.srcData, destIndex);
								this.tmpIndex = destIndex;

								DDM.refreshCache();
							}
						}
						});

		// ////////////////////////////////////////////////////////////////////////////
		// Create DDRows instances when DataTable is initialized
		// ////////////////////////////////////////////////////////////////////////////
		myDataTable.subscribe("initEvent", function() {
			var i, id, allRows = this.getTbodyEl().rows;

			for (i = 0; i < allRows.length; i++) {
				id = allRows[i].id;
				// Clean up any existing Drag instances
				if (myDTDrags[id]) {
					myDTDrags[id].unreg();
					delete myDTDrags[id];
				}
				// Create a Drag instance for each row
				myDTDrags[id] = new YAHOO.example.DDRows(id);
			}
		});

		// ////////////////////////////////////////////////////////////////////////////
		// Create DDRows instances when new row is added
		// ////////////////////////////////////////////////////////////////////////////
		myDataTable.subscribe("rowAddEvent", function(e) {
			var id = e.record.getId();
			myDTDrags[id] = new YAHOO.example.DDRows(id);
		})

		function initDragDrop() {
			var i, id, allRows = this.getTbodyEl().rows;

			for (i = 0; i < allRows.length; i++) {
				id = allRows[i].id;
				// Clean up any existing Drag instances
				if (myDTDrags[id]) {
					myDTDrags[id].unreg();
					delete myDTDrags[id];
				}
				// Create a Drag instance for each row
				myDTDrags[id] = new YAHOO.example.DDRows(id);
			}
		}

		myDataTable.subscribe("cellUpdateEvent", initDragDrop);
		myDataTable.subscribe("columnSortEvent", initDragDrop);
		myDataTable.subscribe("initEvent", initDragDrop);
		myDataTable.subscribe("renderEvent", initDragDrop);

	}();
};

YAHOO.util.Event.addListener(window, "load", foo);