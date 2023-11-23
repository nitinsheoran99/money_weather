import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  String username;
   DashBoardScreen({super.key,required this.username});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
