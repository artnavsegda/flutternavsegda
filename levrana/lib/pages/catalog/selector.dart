import 'package:flutter/material.dart';
import '../../utils.dart';
import '../../components/components.dart';
import '../../gql.dart';

class SelectorPage extends StatefulWidget {
  final GraphFilterGroup? filterGroup;
  final String title;
  final List<GraphFilterValueView> values;
  final String? type;
  final void Function(bool?, int) onChangeFilter;

  const SelectorPage({
    Key? key,
    required this.title,
    required this.filterGroup,
    required this.values,
    required this.type,
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
                    widget.onChangeFilter(newValue, widget.values[index].iD);
                    GraphFilterGroup newFilterGroup;
                    if (filterGroup != null) {
                      newFilterGroup = GraphFilterGroup.from(filterGroup!);
                    } else {
                      newFilterGroup = GraphFilterGroup(iD: 0, values: <int>{});
                    }
                    if (newValue == true) {
                      newFilterGroup.values.add(widget.values[index].iD);
                    } else {
                      newFilterGroup.values.remove(widget.values[index].iD);
                    }
                    setState(() {
                      filterGroup = newFilterGroup;
                    });
                  },
                  value:
                      filterGroup?.values.contains(widget.values[index].iD) ??
                          false,
                  title: SelectorCharacteristic(
                      element: widget.values[index], type: widget.type),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      ),
    );
  }
}

class SelectorCharacteristic extends StatelessWidget {
  const SelectorCharacteristic({
    Key? key,
    required this.element,
    required this.type,
  }) : super(key: key);

  final GraphFilterValueView element;
  final String? type;

  @override
  Widget build(BuildContext context) {
    if (type == 'COLOR') {
      return SizedBox(
        width: 200,
        height: 10,
        child: Container(color: hexToColor(element.name)),
      );
      // return Text('⬤ ',
      //     style: TextStyle(fontSize: 7.0, color: hexToColor(element.name)));
    } else {
      return Text(element.name, style: const TextStyle(fontSize: 16.0));
    }
  }
}

class SortPage extends StatefulWidget {
  final GraphFilter filter;
  final void Function(GraphFilter) onChangeFilter;

  const SortPage({
    Key? key,
    required this.filter,
    required this.onChangeFilter,
  }) : super(key: key);

  @override
  State<SortPage> createState() => _SortPageState();
}

class _SortPageState extends State<SortPage> {
  late GraphFilter filter;

  @override
  void initState() {
    super.initState();
    filter = widget.filter;
  }

  void Function(String?)? setFilter(newVal) {
    var newFilter = GraphFilter.from(widget.filter);
    newFilter.sortType = newVal;
    setState(() {
      filter = newFilter;
    });
    widget.onChangeFilter(newFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Упорядочить")),
        body: Column(
          children: [
            RadioListTile(
              onChanged: setFilter,
              value: 'DEFAULT',
              groupValue: filter.sortType,
              title: const Text("По умолчанию"),
            ),
            RadioListTile(
              onChanged: setFilter,
              value: 'NAME',
              groupValue: filter.sortType,
              title: const Text("По имени"),
            ),
            RadioListTile(
              onChanged: setFilter,
              value: 'PRICE',
              groupValue: filter.sortType,
              title: const Text("По цене"),
            ),
          ],
        ));
  }
}
