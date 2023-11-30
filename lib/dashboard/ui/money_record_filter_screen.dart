import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/model_record.dart';
import 'package:money_watcher/login/util/app_string.dart';


class MoneyRecordFilterScreen extends StatefulWidget {
  const MoneyRecordFilterScreen({super.key, required this.moneyRecordType, required this.onfilterChanged});
  final MoneyRecordType moneyRecordType;
  final Function(MoneyRecordType) onfilterChanged;

  @override
  State<MoneyRecordFilterScreen> createState() => _MoneyRecordFilterScreenState();
}

class _MoneyRecordFilterScreenState extends State<MoneyRecordFilterScreen> {
  late MoneyRecordType moneyRecordType;
  @override
  void initState() {
    moneyRecordType=widget.moneyRecordType;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filter),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
   children: [
     Text(filterType,style: TextStyle(fontSize: 20),),
     Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         ChoiceChip(label: Text(income), selected: moneyRecordType == MoneyRecordType.income,
         onSelected: (bool selected){
           if(selected){
             setState(() {
               moneyRecordType= MoneyRecordType.income;
             });
             widget.onfilterChanged(MoneyRecordType.income);
           }
         },
         ),
         ChoiceChip(label: Text(radioTextExpense), selected: moneyRecordType == MoneyRecordType.expense,
           onSelected: (bool selected){
             if(selected){
               setState(() {
                 moneyRecordType= MoneyRecordType.expense;
               });
               widget.onfilterChanged(MoneyRecordType.expense);
             }
           },
         ),
       ],
     )
   ],

        ),
      ),
    );
  }
}
