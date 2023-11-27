import 'package:flutter/material.dart';
import 'package:money_weather/dashboard/model/model_record.dart';


class MoneyRecordListItemWidget extends StatelessWidget {
  const MoneyRecordListItemWidget({super.key, required this.moneyRecord});

  final MoneyRecord moneyRecord;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: moneyRecord.type == MoneyRecordType.expense
            ? Colors.red[100]
            : Colors.green[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(moneyRecord.title),
          Text(moneyRecord.amount.toString())
        ],
      ),
    );
  }
}