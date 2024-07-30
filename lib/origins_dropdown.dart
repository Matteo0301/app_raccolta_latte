import 'dart:io';

import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:app_raccolta_latte/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class OriginsDropdown extends StatelessWidget {
  OriginsDropdown(this.onChanged, {super.key, this.includeSelectAll = false});
  final void Function(String, bool) onChanged;
  final bool includeSelectAll;
  static List<Origin>? origins;

  Future<LocationData?> getLocation() async {
    if (!kIsWeb && !Platform.isAndroid) return null;
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();
    debugPrint('$locationData');
    return locationData;
  }

  getSortedOrigins() async {
    if (origins != null) {
      return origins;
    }
    final LocationData? location;
    location = await getLocation();
    final newOrigins = await getOrigins();
    if (location != null) {
      newOrigins
          .sort((a, b) => a.distance(location).compareTo(b.distance(location)));
    }
    origins = newOrigins;
    return newOrigins;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Padding(
        padding: EdgeInsets.all(MyTheme.padding),
        child: Text('Conferente: '),
      ),
      FutureBuilder(
        future: getSortedOrigins(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Nessun conferente trovato'));
          } else if (snapshot.hasData) {
            List<Origin> list = snapshot.data as List<Origin>;
            return OriginsDropdownHelper(list, onChanged, includeSelectAll);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    ]);
  }
}

class OriginsDropdownHelper extends StatefulWidget {
  const OriginsDropdownHelper(
      this.origins, this.onChanged, this.includeSelectAll,
      {super.key});
  final List<Origin> origins;
  final void Function(String, bool) onChanged;
  final bool includeSelectAll;

  @override
  State<StatefulWidget> createState() => DropdownState();
}

class DropdownState extends State<OriginsDropdownHelper> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    if (widget.origins.isEmpty) return const Text('Nessun conferente trovato');
    if (widget.includeSelectAll && widget.origins[0].name != 'Tutti') {
      widget.origins.insert(0, Origin('Tutti', 0, 0));
    }
    if (selected == '') {
      selected = widget.origins[0].name;
      widget.onChanged(selected, false);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selected,
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
        ),
        onChanged: (value) {
          setState(() {
            if (value == null) {
              selected = '';
            } else {
              selected = value;
              widget.onChanged(selected, true);
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
