import 'package:flutter/material.dart';
import 'package:socialapp/features/home/presentation/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),

      // drawer
      drawer: MyDrawer(),

      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
