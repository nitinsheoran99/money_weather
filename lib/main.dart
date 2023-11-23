import 'package:flutter/material.dart';
import 'package:money_weather/login/provider/auth_provider.dart';
import 'package:money_weather/login/service/database_service.dart';
import 'package:money_weather/login/ui/login_screen.dart';
import 'package:money_weather/login/util/app_string.dart';

import 'package:provider/provider.dart';

Future main()async{
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService databaseService = DatabaseService();
  await databaseService.initDatabase();
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
          return AuthProvider(databaseService);
        })
      ],
      child: MaterialApp(
        title: appName,debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
