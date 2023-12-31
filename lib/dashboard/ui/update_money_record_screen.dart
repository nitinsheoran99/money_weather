import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/model_record.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:money_watcher/login/util/app_color.dart';
import 'package:money_watcher/login/util/app_constant.dart';
import 'package:money_watcher/login/util/app_string.dart';
import 'package:money_watcher/login/util/app_util.dart';
import 'package:money_watcher/login/util/login_widget.dart';
import 'package:money_watcher/login/util/radio_button_widget.dart';


import 'package:provider/provider.dart';

class EditMoneyRecordScreen extends StatefulWidget {
  const EditMoneyRecordScreen({super.key, required this.moneyRecord});
  final MoneyRecord moneyRecord;

  @override
  EditMoneyRecordScreenState createState() => EditMoneyRecordScreenState();
}

class EditMoneyRecordScreenState extends State<EditMoneyRecordScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  late String selectedCategory;

  int selectedDate = DateTime.now().millisecondsSinceEpoch;
  MoneyRecordType selectedType = MoneyRecordType.expense;

  List<String> categories = AppConstant.getRecordCategories();

  @override
  void initState() {
    selectedCategory = widget.moneyRecord.category;
    titleController.text = widget.moneyRecord.title;
    amountController.text = widget.moneyRecord.amount.toString();
    selectedDate = widget.moneyRecord.date;
    selectedType = widget.moneyRecord.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(editMoneyTitleText),
    ),
    body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    AppTextField(
    controller: titleController,
    hintText: hintTextTitle,
    ),
    const SizedBox(
    height: 16,
    ),
    AppTextField(
    controller: amountController,
    keyboardType:
    const TextInputType.numberWithOptions(decimal: true),
    hintText: hintTextAmount,
    ),
    const SizedBox(height: 16),
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16.0),
    border: Border.all(color: Colors.grey),
    ),
    child: DropdownButtonFormField(
    value: selectedCategory,
    onChanged: (value) {
    setState(() {
    selectedCategory = value as String;
    });
    },
    items:
    categories.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    decoration: const InputDecoration(
    labelText: labelTextCategory, border: InputBorder.none),
    ),
    ),
    const SizedBox(height: 16),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(AppUtil.formattedDate(selectedDate)),
    TextButton(
    onPressed: () => _selectDate(context),
    child: const Text(selectDateText),
    ),
    ],
    ),
    const SizedBox(height: 16),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    RadioButtonWidget<MoneyRecordType>(value: MoneyRecordType.income,
      selectedValue: selectedType,
      onChanged: (value) {
        setState(() {
          selectedType = value;
        });
      },
      title: radioTextIncome,
    ),
      RadioButtonWidget<MoneyRecordType>(
        value: MoneyRecordType.expense,
        selectedValue: selectedType,
        onChanged: (value) {
          setState(() {
            selectedType = value;
          });
        },
        title: radioTextExpense,
      ),
    ],
    ),
      const SizedBox(height: 16),
      InkWell(
        onTap: () async{
          await editMoneyRecord();
          fetchMoneyRecord();
        },
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: buttonBackground,
              borderRadius: BorderRadius.circular(24)),
          child: const Text(
            editTextButton,
            style: TextStyle(color: buttonTextColor),
          ),
        ),
      )
    ],
    ),
    ),
    ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked.millisecondsSinceEpoch;
      });
    }
  }

  Future editMoneyRecord() async {
    MoneyRecord moneyRecord = MoneyRecord(
      id: widget.moneyRecord.id,
      title: titleController.text,
      amount: double.parse(amountController.text),
      category: selectedCategory,
      date: selectedDate,
      type: selectedType,
    );

    final moneyProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    await moneyProvider.editMoneyRecord(moneyRecord);
    await moneyProvider.getMoneyRecords();

    if (moneyProvider.error == null) {
      if (mounted) {
        AppUtil.showToast(recordEditMsg);
        Navigator.pop(context);
      }
    }
  }

  Future fetchMoneyRecord()async{
    final moneyProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    moneyProvider.getMoneyRecords();
  }
}