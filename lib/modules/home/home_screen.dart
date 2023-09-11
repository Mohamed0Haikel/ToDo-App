import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.amber),
          onPressed: () {},
        ),
        title: const Text(
          'App Name',
          style: TextStyle(color: Colors.amber),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications, color: Colors.amber),
              onPressed: () {}),
        ],
        centerTitle: true,
      ),
      body:Column(
        children: [

        ],
      ),

      

    );
  }
}
