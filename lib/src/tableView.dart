import 'package:flutter/material.dart';
import 'package:lazy_data_table/lazy_data_table.dart';
import 'tracker_list.dart';
import 'work_item_list.dart';
import 'field_list.dart';

Widget tableView(BuildContext context, List<List<String>> data,
    List<String> header, Map<int, double> colWidths, String type,
    {bool listOfFields = false}) {
  return LazyDataTable(
    rows: data.length,
    columns: header.length,
    tableDimensions: LazyDataTableDimensions(
      customCellWidth: colWidths,
    ),
    tableTheme: LazyDataTableTheme(
        columnHeaderBorder: Border.all(color: Colors.orange),
        columnHeaderColor: Colors.orange,
        rowHeaderBorder: Border.all(color: Colors.orange),
        rowHeaderColor: Colors.orange,
        cornerBorder: Border.all(color: Colors.orange),
        cornerColor: Colors.orange,
        cellBorder: Border.all(color: Colors.orange),
        cellColor: Colors.white,
        alternateRow: false,
        alternateColumn: false),
    topHeaderBuilder: (i) => Center(
        child: Text(
      header[i],
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15.0,
      ),
    )),
    dataCellBuilder: (i, j) => Center(
        child: InkWell(
            child: Text(data[i][j] ?? ' '),
            onTap: () {
              switch (type) {
                case 'Project':
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => TrackerList(
                            context: context,
                            projectID: int.parse(data[i][0]),
                            projectName: data[i][1]),
                      ),
                    );
                    break;
                  }
                case 'WorkItem':
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => WorkItemList(
                            context: context,
                            trackerID: int.parse(data[i][0]),
                            trackerName: data[i][1]),
                      ),
                    );
                    break;
                  }
                case 'Field':
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => FieldList(
                            context: context,
                            trackerID: int.parse(data[i][0]),
                            trackerName: data[i][1]),
                      ),
                    );
                    break;
                  }
                default:
                  {
                    break;
                  }
              }
            })),
  );
}
