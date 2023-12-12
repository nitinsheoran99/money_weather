import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/model_record.dart';
import 'package:money_watcher/login/util/app_color.dart';
import 'package:money_watcher/login/util/app_util.dart';



class MoneyRecordDetailScreen extends StatefulWidget {
   MoneyRecordDetailScreen({super.key,required this.moneyRecord});

  final MoneyRecord moneyRecord;

  @override
  State<MoneyRecordDetailScreen> createState() =>
      _MoneyRecordDetailScreenState();
}

class _MoneyRecordDetailScreenState extends State<MoneyRecordDetailScreen> {
  final List<String> imagePaths=[];
  void deletePhoto() {
    try {
      File file = File(widget.moneyRecord.path);

      if (file.existsSync()) {
        file.deleteSync();
        print('Photo deleted successfully');
      } else {
        print('File not found');
      }
    } catch (e) {
      print('Error deleting photo: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppUtil.formattedDate(widget.moneyRecord.date)),
        ),
        backgroundColor: widget.moneyRecord.type == MoneyRecordType.expense
            ? expenseColor
            : incomeColor,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              moneyRecordRow(
                label: 'Name',
                value: widget.moneyRecord.title,
              ),
              moneyRecordRow(
                label: 'Amount',
                value: widget.moneyRecord.amount.toString(),
              ),
              moneyRecordRow(
                label: 'Category',
                value: widget.moneyRecord.category,
              ),
              GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Photo'),
                        content: Text('Are you sure you want to delete this photo?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {

                              deletePhoto();
                              setState(() {

                              });
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    if(imagePaths.isEmpty)
                    Image.file(
                      File(widget.moneyRecord.path),
                      height: 170,
                      width: 170,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget moneyRecordRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}