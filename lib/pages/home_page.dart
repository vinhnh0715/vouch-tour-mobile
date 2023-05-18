import "package:flutter/material.dart";
import "package:vouch_tour_mobile/utils/drawer.dart";

class HomePage extends StatelessWidget {
  int age = 20;
  String name = "Trong Nghia";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Catalog App",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Text("Hello my name is $name, I'm $age years old"),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
