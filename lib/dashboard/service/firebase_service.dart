import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:money_watcher/dashboard/model/model_record.dart';


class MoneyWatcherFirebaseService {
  final DatabaseReference _reference = FirebaseDatabase.instance.ref();

  Future<void> addMoneyRecord(MoneyRecord moneyRecord) async {
    try {
      DatabaseReference newRecordRef = _reference.child('money_record');
      String id = newRecordRef.push().key!;
      moneyRecord.id = id;
      await newRecordRef.child(id).set(moneyRecord.toJson());
    } catch (error) {
      if (kDebugMode) {
        print('Error adding moneyRecord: $error');
      }
      rethrow;
    }
  }

  Stream<DatabaseEvent> listenMoneyWatcher(){
    return _reference.child('money_record').onValue;
  }

  Future<List<MoneyRecord>> fetchMoneyRecord() async {
    DataSnapshot dataSnapshot = await _reference.child('money_record').get();
    if (dataSnapshot.exists) {
      dynamic map = dataSnapshot.value;
      if (map is Map<dynamic, dynamic>) {
        List<MoneyRecord> moneyRecordList = [];
        map.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            moneyRecordList
                .add(MoneyRecord.fromJson(Map<String, dynamic>.from(value)));
          }
        });
        return moneyRecordList;
      } else {
        throw 'Invalid data moneyRecord';
      }
    }
    throw 'MoneyRecord not found';
  }

  Future<void> deleteMoneyRecord(String id) async {
    try {
      await _reference.child('money_record').child(id).remove();
    } catch (error) {
      if (kDebugMode) {
        print('Error deleting moneyRecord: $error');
      }
      rethrow;
    }
  }

  Future<void> editMoneyRecord(
      String id, MoneyRecord updatedInformation) async {
    try {
      await _reference.child('money_record').child(id).update(updatedInformation.toJson());
    } catch (error) {
      if (kDebugMode) {
        print('Error updating moneyRecord: $error');
      }
      rethrow;
    }
  }
}