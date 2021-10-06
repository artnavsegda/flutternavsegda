import 'package:flutter/material.dart';
import 'filter.dart';
import '../components.dart';

class SelectorPage extends StatefulWidget {
  final GraphFilterGroup? filterGroup;
  final String title;
  final values;
  final onChangeFilter;

  const SelectorPage({
    Key? key,
    required this.title,
    required this.filterGroup,
    required this.values,
    required this.onChangeFilter,
  }) : super(key: key);

  @override
  State<SelectorPage> createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
  late GraphFilterGroup? filterGroup;

  @override
  void initState() {
    super.initState();
    filterGroup = widget.filterGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: widget.values.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                LevranaCheckboxTitle(
                  onChanged: (newValue) {
                    widget.onChangeFilter(newValue, widget.values[index]['iD']);
                    var newFilterGroup;
                    if (filterGroup != null)
                      newFilterGroup = GraphFilterGroup.from(filterGroup!);
                    else
                      newFilterGroup = GraphFilterGroup(iD: 0, values: <int>{});
                    if (newValue == true) {
                      newFilterGroup.values.add(widget.values[index]['iD']);
                    } else {
                      newFilterGroup.values.remove(widget.values[index]['iD']);
                    }
                    setState(() {
                      filterGroup = newFilterGroup;
                    });
                  },
                  value: filterGroup?.values
                          .contains(widget.values[index]['iD']) ??
                      false,
                  title: Text(widget.values[index]['name'],
                      style: TextStyle(fontSize: 16.0)),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ),
    );
  }
}
