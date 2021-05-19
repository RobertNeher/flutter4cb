import 'package:flutter/material.dart';
import 'package:lazy_data_table/lazy_data_table.dart';
import 'tracker_list.dart';

Widget tableView(BuildContext context, List<List<String>> data,
    List<String> header, Map<int, double> colWidths, String type) {
  if (data.length <= 1 || header.length <= 1)
    return Center(child: Text('nothing to display'));

  return LazyDataTable(
    rows: data.length - 1,
    columns: header.length - 1,
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
    // leftHeaderBuilder: (i) => Center(child: SizedBox.shrink()),
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
                  }
                  break;
                case 'Tracker':
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
                  }
                  break;
                case 'Field':
                  {}
                  break;
                default:
                  {}
                  break;
              }
            })),
  );
}
