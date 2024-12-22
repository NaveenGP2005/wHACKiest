import 'package:flutter/material.dart';
import 'package:whackiest/services/stripe.dart';

void main() => runApp(MyAppPay());

class MyAppPay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Boilerplate',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  String amt='5000';
  String cur='USD';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(child: Text('Hello, Flutter!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          try {
            await StripeService.initPaymentSheet(amt, cur);
            await StripeService.presentPaymentSheet();
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
