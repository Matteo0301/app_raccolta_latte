import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:flutter/material.dart';

class DetailsTable extends StatelessWidget {
  final DateTime date;
  final ValueGetter<Future<List<Collection>>> request;

  const DetailsTable({super.key, required this.date, required this.request});

  int getDay(Collection c){
    final DateTime res;
    if(c.date.hour >= 12){
      res = c.date.copyWith(day: c.date.day + 1);
    }else{
      res = c.date;
    }
    return res.day;
  }

  String getRow (Collection c){
    return (c.date.hour >= 12)?'sera':'mattina';
  }

  Map<String, Map<int, int>> getMap(List<Collection> coll){
    final Map<String, Map<int, int>> res = {};
    for (var element in coll) {
      final String row = getRow(element);
      final int day = getDay(element);
      if (!res.containsKey(row)) {
        res[row] = {};
      }
      final int old = (res[row]![day])??0;
      res[row]![day]=old+element.quantity+element.quantity2;
    }
    return res;
  }
  
  @override
  Widget build(BuildContext context) {
    DateTime end = date.copyWith(month: date.month + 1, day: 0, hour: 12);
    List<DataColumn> columns = [const DataColumn(label: Text('Conferente',
              style: TextStyle(fontWeight: FontWeight.bold)))];
    for(int i=1;i<=end.day;i++){
      columns.add(DataColumn(label: Text('$i', style: const TextStyle(fontWeight: FontWeight.bold))));
    }
    columns.add(const DataColumn(label: Text('Totale',
              style: TextStyle(fontWeight: FontWeight.bold))));

    return FutureBuilder(future: request(), builder: (context, snapshot) {
      if (snapshot.hasError) {
          return const Center(child: Text('Nessun dato trovato'));
        } else if (snapshot.hasData&& snapshot.data!=null) {
          final Map<String,Map<int,int>> map = getMap(snapshot.data!);
          final List<DataRow> rows = [];
          for (var key in map.keys) {
            final List<DataCell> row = [DataCell(Text(key))];
            int total = 0;
            for (int i = 1; i <= end.day; i++) {
              int quantity = map[key]![i]??0;
              row.add(DataCell(Text('$quantity')));
              total+=quantity;
            }
            row.add(DataCell(Text('$total',
                style: const TextStyle(fontWeight: FontWeight.bold))));
            rows.add(DataRow(cells: row));
          }
          return SingleChildScrollView(

            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              columns: columns,
              rows: rows,
            ),
          ) ;
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      
    },);
    
  }
}