
import 'package:money_weather/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const String tableName = 'user';

  late Database database;

  Future initDatabase() async {

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'money_tracker.db');
    database =
    await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'create table $tableName(email text primary key,name text,password text)');
      print('Table create successfully');
    });
  }

  Future registerUser(User user) async {
    await database.rawInsert('insert into $tableName values(?,?,?)',
        [user.email, user.name, user.password]);
    print('User added successfully');
  }

  Future<bool> isUserExists(User user) async {
    List list = await database.rawQuery(
        'select * from $tableName where email=? AND password=?',
        [user.email, user.password,]);
    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}