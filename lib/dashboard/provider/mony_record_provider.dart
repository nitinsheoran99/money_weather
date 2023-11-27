import 'package:flutter/material.dart';
import 'package:money_weather/dashboard/model/model_record.dart';
import 'package:money_weather/login/service/database_service.dart';


class MoneyRecordProvider extends ChangeNotifier {
  MoneyRecordProvider(this.databaseService);

  List<MoneyRecord> moneyRecordList = [];
  DatabaseService databaseService;
  bool isLoading = false;
  String? error;

  Future addMoneyRecord(MoneyRecord moneyRecord) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      await databaseService.addMoneyRecord(moneyRecord);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future getMoneyRecords() async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      moneyRecordList = await databaseService.getMoneyRecords();
      notifyListeners();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}