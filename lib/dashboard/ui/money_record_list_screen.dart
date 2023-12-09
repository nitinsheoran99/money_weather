import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_watcher/dashboard/model/model_record.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:money_watcher/dashboard/ui/add_money_record_screen.dart';
import 'package:money_watcher/dashboard/ui/detail_screen.dart';
import 'package:money_watcher/dashboard/ui/money_record_filter_screen.dart';
import 'package:money_watcher/login/util/money_recorded_list_item_widget.dart';

import 'package:provider/provider.dart';

import 'update_money_record_screen.dart';

class MoneyRecordListScreen extends StatefulWidget {
  const MoneyRecordListScreen({Key? key}) : super(key: key);

  @override
  State<MoneyRecordListScreen> createState() => _MoneyRecordListScreenState();
}

class _MoneyRecordListScreenState extends State<MoneyRecordListScreen> {
  late MoneyRecordType filterType;
  late String filterCategory;

  @override
  void initState() {
    filterType = MoneyRecordType.all;
    filterCategory = '';
    Future.delayed(Duration.zero, () {
      fetchMoneyRecord();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Records'),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  openFilterScreen();
                },
              ),
              IconButton(
                icon: const Icon(Icons.layers_clear),
                onPressed: () {
                  openFilterScreen();
                },
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddMoneyRecordScreen,
        child: const Icon(Icons.add),
      ),
      body: Consumer<MoneyRecordProvider>(
        builder: (context, moneyRecordProvider, widget) {
          List<MoneyRecord> filteredRecords =
          applyFilter(moneyRecordProvider.moneyRecordList);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                MoneyRecord moneyRecord = filteredRecords[index];
                return Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          showDeleteConfirmDialog(moneyRecord);
                        },
                        icon: Icons.delete,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          openEditMoneyRecordScreen(moneyRecord);
                        },
                        icon: Icons.edit,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return MoneyRecordDetailScreen(
                              moneyRecord: moneyRecord,
                            );
                          }));
                    },
                    child: MoneyRecordListItemWidget(
                      moneyRecord: moneyRecord,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: filteredRecords.length,
            ),

          );

        },

      ),
    );
  }

  Future fetchMoneyRecord() async {
    final moneyProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    moneyProvider.getMoneyRecords();
  }

  void showDeleteConfirmDialog(MoneyRecord moneyRecord) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Alert"),
          content: const Text("Are you sure want to delete this?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if(moneyRecord.id!=null) {
                  deleteMoneyRecord(moneyRecord.id!);
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Okay"),
            )
          ],
        );
      },
    );
  }

  void openEditMoneyRecordScreen(MoneyRecord moneyRecord) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditMoneyRecordScreen(moneyRecord: moneyRecord);
    }));
  }

  void openAddMoneyRecordScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const AddMoneyRecordScreen();
    }));
  }

  Future deleteMoneyRecord(String id) async {
    MoneyRecordProvider moneyRecordProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    await moneyRecordProvider.deleteMoneyRecord(id);
    if (moneyRecordProvider.error == null) {
      moneyRecordProvider.getMoneyRecords();
    }
  }

  void openFilterScreen() {
    showModalBottomSheet(
      context: context,
      builder: (context) => MoneyRecordFilterScreen(
        moneyRecordType: filterType,
        onfilterChanged: (MoneyRecordType? selectedType) {
          if (selectedType != null) {
            setState(() {
              filterType = selectedType;
            });
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  List<MoneyRecord> applyFilter(List<MoneyRecord> records) {
    if (filterType == MoneyRecordType.all && filterCategory.isEmpty) {
      return records;
    } else {
      return records
          .where((record) =>
      (filterType == MoneyRecordType.all || record.type == filterType) &&
          (filterCategory.isEmpty || record.category == filterCategory))
          .toList();
    }
  }
}