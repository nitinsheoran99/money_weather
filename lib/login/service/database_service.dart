

import 'package:flutter/foundation.dart';
import 'package:money_watcher/dashboard/model/model_record.dart';
import 'package:money_watcher/login/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const String userTableName = 'user';
  static const String moneyRecordTableName = 'money_record';

  late Database database;

  Future initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'money_tracker.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        createUserTable(db);
        createMoneyRecordTable(db);
        if (kDebugMode) {
          print('Table create successfully');
        }
      },
    );
  }

  Future<void> createMoneyRecordTable(Database db) async {
    await db.execute('create table $moneyRecordTableName(id integer primary key'
        ' autoincrement,title text,amount real,category text,'
        'date integer,type text)');
  }

  Future<void> createUserTable(Database db) async {
    await db
        .execute('create table $userTableName(email text primary key,name text,'
        'password text)');
  }

  Future registerUser(User user) async {
    // await database.rawInsert(
    //     "insert into $userTableName values('${user.email}','${user.name}','${user.password}')");
    await database.rawInsert('insert into $userTableName values(?,?,?)',
        [user.email, user.name, user.password]);
    if (kDebugMode) {
      print('User added successfully');
    }
  }

  Future<bool> isUserExists(User user) async {
    List list = await database
        .rawQuery('select * from $userTableName where email=? AND password=?', [
      user.email,
      user.password,
    ]);
    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future addMoneyRecord(MoneyRecord moneyRecord) async {
    await database.rawInsert(
        'insert into $moneyRecordTableName (title,amount,category,'
            'date,type) values(?,?,?,?,?)',
        [
          moneyRecord.title,
          moneyRecord.amount,
          moneyRecord.category,
          moneyRecord.date,
          moneyRecord.type.toString(),
        ]);
    if (kDebugMode) {
      print('Money Record added successfully');
    }
  }

  Future<void> editMoneyRecord(MoneyRecord record) async {
    await database.rawUpdate(
      '''
      UPDATE $moneyRecordTableName 
      SET title = ?, amount = ?, category = ?, date = ?, type = ? 
      WHERE id = ?
      ''',
      [
        record.title,
        record.amount,
        record.category,
        record.date,
        record.type.toString(),
        record.id,
      ],
    );
    if (kDebugMode) {
      print('Money Record updated successfully');
    }
  }

  Future deleteMoneyRecord(int id) async {
    await database.rawInsert(
      'delete from $moneyRecordTableName where id=?',
      [id],
    );
    if (kDebugMode) {
      print('Money Record deleted successfully');
    }
  }

  Future<List<MoneyRecord>> getMoneyRecords() async {
    List<Map<String, dynamic>> records =
    await database.rawQuery('Select * from $moneyRecordTableName');
    List<MoneyRecord> moneyRecordList = [];

    for (int i = 0; i < records.length; i++) {
      Map<String, dynamic> map = records[i];
      MoneyRecord moneyRecord = MoneyRecord.fromJson(map);
      moneyRecordList.add(moneyRecord);
    }

    return moneyRecordList;
  }
}