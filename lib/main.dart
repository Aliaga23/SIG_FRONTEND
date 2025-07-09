import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/delivery_provider.dart';
import 'screens/delivery_home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeliveryProvider(),
      child: MaterialApp(
        title: 'SIG Shoes - Repartidor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DeliveryHomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
