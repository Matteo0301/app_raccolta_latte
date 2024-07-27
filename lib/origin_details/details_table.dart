import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class DetailsTable extends StatelessWidget {
  final DateTime date;
  final ValueGetter<Future<List<Collection>>> request;

  const DetailsTable({super.key, required this.date, required this.request});

  int getDay(Collection c) {
    final DateTime res;
    if (c.date.hour >= 12) {
      res = c.date.copyWith(day: c.date.day + 1);
    } else {
      res = c.date;
    }
    return res.day;
  }

  String getRow(Collection c) {
    return (c.date.hour >= 12) ? 'sera' : 'mattina';
  }

  Map<String, Map<int, int>> getMap(List<Collection> coll) {
    final Map<String, Map<int, int>> res = {};
    for (var element in coll) {
      final String row = getRow(element);
      final int day = getDay(element);
      if (!res.containsKey(row)) {
        res[row] = {};
      }
      final int old = (res[row]![day]) ?? 0;
      res[row]![day] = old + element.quantity + element.quantity2;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    DateTime end = date.copyWith(month: date.month + 1, day: 0, hour: 12);
    List<Container> columns = [];
    const leftWidth = 100.0;
    const rightWidth = 65.0;
    const height = 40.0;
    const leftPadding = 10.0;
    BoxDecoration decoration = BoxDecoration(
      border: Border.all(color: Colors.black),
    );
    for (int i = 1; i <= end.day; i++) {
      columns.add(Container(
          decoration: decoration,
          width: rightWidth,
          height: height,
          child: Padding(
              padding: const EdgeInsets.all(leftPadding),
              child: Text('$i',
                  style: const TextStyle(fontWeight: FontWeight.bold)))));
    }
    columns.add(Container(
        decoration: decoration,
        width: rightWidth,
        height: height,
        child: const Padding(
            padding: EdgeInsets.all(leftPadding),
            child: Text('Totale',
                style: TextStyle(fontWeight: FontWeight.bold)))));

    return FutureBuilder(
      future: request(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Nessun dato trovato'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final Map<String, Map<int, int>> map = getMap(snapshot.data!);
          final List<Row> leftRows = [
            Row(
              children: [
                Container(
                    decoration: decoration,
                    width: leftWidth,
                    height: height,
                    child: const Padding(
                        padding: EdgeInsets.all(leftPadding),
                        child: Text('Conferente',
                            style: TextStyle(fontWeight: FontWeight.bold))))
              ],
            )
          ];
          final List<Row> rightRows = [
            Row(
              children: columns,
            )
          ];
          for (var key in ['sera', 'mattina']) {
            final List<Container> left = [
              Container(
                  decoration: decoration,
                  width: leftWidth,
                  height: height,
                  child: Padding(
                      padding: const EdgeInsets.all(leftPadding),
                      child: Text(key)))
            ];
            final List<Container> right = [];
            int total = 0;
            for (int i = 1; i <= end.day; i++) {
              int quantity = map[key] != null ? (map[key]![i] ?? 0) : 0;
              right.add(Container(
                  decoration: decoration,
                  width: rightWidth,
                  height: height,
                  child: Padding(
                      padding: const EdgeInsets.all(leftPadding),
                      child: Text('$quantity'))));
              total += quantity;
            }
            right.add(Container(
                decoration: decoration,
                width: rightWidth,
                height: height,
                child: Padding(
                    padding: const EdgeInsets.all(leftPadding),
                    child: Text('$total',
                        style: const TextStyle(fontWeight: FontWeight.bold)))));
            leftRows.add(Row(
              children: left,
            ));
            rightRows.add(Row(
              children: right,
            ));
          }
          return SizedBox(
              height: 3 * height + 10,
              width: MediaQuery.of(context).size.width,
              child: HorizontalDataTable(
                leftHandSideColumnWidth: leftWidth,
                rightHandSideColumnWidth: 2100,
                leftSideChildren: leftRows,
                rightSideChildren: rightRows,
                horizontalScrollbarStyle:
                    const ScrollbarStyle(isAlwaysShown: true),
              ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
