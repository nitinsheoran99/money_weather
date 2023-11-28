import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_weather/dashboard/model/model_record.dart';
import 'package:money_weather/dashboard/provider/mony_record_provider.dart';
import 'package:money_weather/dashboard/ui/add_mony_record_screen.dart';
import 'package:money_weather/dashboard/ui/detail_screen.dart';
import 'package:money_weather/dashboard/ui/money_record_filter_screen.dart';
import 'package:money_weather/dashboard/ui/update_money_record_screen.dart';
import 'package:money_weather/login/util/money_recorded_list_item_widget.dart';

import 'package:provider/provider.dart';

class MoneyRecordListScreen extends StatefulWidget {
  const MoneyRecordListScreen({super.key});

  @override
  State<MoneyRecordListScreen> createState() => _MoneyRecordListScreenState();
}

class _MoneyRecordListScreenState extends State<MoneyRecordListScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchMoneyRecord();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return MoneyRecordFilterScreen();
            }));
          }, icon: Icon(Icons.filter_list))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddMoneyRecordScreen,
        child: const Icon(Icons.add),
      ),
      body: Consumer<MoneyRecordProvider>(
        builder: (context, moneyRecordProvider, widget) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  MoneyRecord moneyRecord =
                  moneyRecordProvider.moneyRecordList[index];
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
                itemCount: moneyRecordProvider.moneyRecordList.length),
          );
        },
      ),
    );
  }

  Future fetchMoneyRecord() async {
    final moneyProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    moneyProvider.getMoneyRecords();
  }void showDeleteConfirmDialog(MoneyRecord moneyRecord) {
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
                  deleteMoneyRecord(moneyRecord.id!);
                  Navigator.of(context).pop();
                },
                child: const Text("Okay"),
              )
            ],
          );
        });
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

  Future deleteMoneyRecord(int id) async {
    MoneyRecordProvider moneyRecordProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    await moneyRecordProvider.deleteMoneyRecord(id);
    if (moneyRecordProvider.error == null) {
      moneyRecordProvider.getMoneyRecords();
    }
  }
  void showDeleteConfirmsDialog(MoneyRecord moneyRecord) {
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
                deleteMoneyRecord(moneyRecord.id!);
                Navigator.of(context).pop(); // Close the delete confirmation dialog
                 // Open the MoneyRecordFilterScreen
              },
              child: const Text("Okay"),
            )
          ],
        );
      },
    );
  }



}