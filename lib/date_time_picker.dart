import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  DateTimePicker(
      {Key? key,
      required this.date,
      required this.onChanged,
      required this.admin})
      : super(key: key);
  DateTime date;
  final ValueSetter<DateTime> onChanged;
  final bool admin;

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now(),
        currentDate: widget.date);
    print(picked);

    if (picked != null) {
      setState(() {
        widget.date = widget.date
            .copyWith(year: picked.year, month: picked.month, day: picked.day);
        widget.onChanged(widget.date);
      });
    }
  }

  void selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: widget.date.hour, minute: widget.date.minute));
    print(picked);

    if (picked != null) {
      setState(() {
        widget.date =
            widget.date.copyWith(hour: picked.hour, minute: picked.minute);
        widget.onChanged(widget.date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.admin) {
      return Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Data'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '${widget.date.day}/${widget.date.month}/${widget.date.year}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () => selectDate(context),
                    icon: const Icon(Icons.date_range)),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Ora'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${widget.date.hour}:${widget.date.minute}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () => selectTime(context),
                    icon: const Icon(Icons.access_time)),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Data'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '${widget.date.day}/${widget.date.month}/${widget.date.year}'),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Ora'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${widget.date.hour}:${widget.date.minute}'),
              ),
            ],
          ),
        ],
      );
    }
  }
}
