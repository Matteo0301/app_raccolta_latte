import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/material.dart';

class OriginsDropdown extends StatelessWidget {
  const OriginsDropdown(this.onChanged, {Key? key}) : super(key: key);
  final ValueSetter<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Conferente: '),
      ),
      FutureBuilder(
        future: getOrigins(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Nessun dato trovato'));
          } else if (snapshot.hasData) {
            List<Origin> list = snapshot.data as List<Origin>;
            return OriginsDropdownHelper(list, onChanged);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    ]);
  }
}

class OriginsDropdownHelper extends StatefulWidget {
  const OriginsDropdownHelper(this.origins, this.onChanged, {super.key});
  final List<Origin> origins;
  final ValueSetter<String> onChanged;

  @override
  State<StatefulWidget> createState() => DropdownState();
}

class DropdownState extends State<OriginsDropdownHelper> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    if (widget.origins.isEmpty) return const Text('Nessun dato trovato');
    if (selected == '') selected = widget.origins[0].name;
    widget.onChanged(selected);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selected,
        iconSize: 24,
        elevation: 16,
        //style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          //color: Colors.deepPurpleAccent,
        ),
        onChanged: (value) {
          setState(() {
            if (value == null) {
              selected = '';
            } else {
              selected = value;
              widget.onChanged(selected);
            }
          });
        },
        items: widget.origins.map<DropdownMenuItem<String>>((Origin value) {
          return DropdownMenuItem<String>(
            value: value.name,
            child: Text(value.name),
          );
        }).toList(),
      ),
    );
  }
}
