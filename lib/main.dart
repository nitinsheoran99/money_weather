import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:money_watcher/dashboard/service/firebase_service.dart';
import 'package:money_watcher/firebase_auth/auth_service.dart';
import 'package:money_watcher/firebase_options.dart';
import 'package:money_watcher/image_picker_screen.dart';
import 'package:money_watcher/login/provider/auth_provider.dart';
import 'package:money_watcher/login/service/database_service.dart';
import 'package:money_watcher/login/ui/login_screen.dart';
import 'package:money_watcher/login/util/app_string.dart';
import 'package:provider/provider.dart';

Future main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DatabaseService databaseService = DatabaseService();
  await databaseService.initDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(databaseService:databaseService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,required this.databaseService});

  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context){
          return AuthProvider(AuthService());
        }),
        ChangeNotifierProvider(
          create: (context) {
            return MoneyRecordProvider(MoneyWatcherFirebaseService());
          },
        ),
      ],
      child: MaterialApp(
        title: appName,debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:  LoginScreen(),
      ),
    );
  }
}
