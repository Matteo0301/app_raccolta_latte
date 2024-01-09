import 'dart:io';

import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class OriginsDropdown extends StatelessWidget {
  const OriginsDropdown(this.onChanged, {super.key});
  final ValueSetter<String> onChanged;

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
    print(locationData);
    return locationData;
  }

  getSortedOrigins() async {
    final LocationData? location;
    location = await getLocation();
    final origins = await getOrigins();
    if (location != null) {
      origins
          .sort((a, b) => a.distance(location).compareTo(b.distance(location)));
    }
    return origins;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Conferente: '),
      ),
      FutureBuilder(
        future: getSortedOrigins(),
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
