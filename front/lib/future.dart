import 'package:flutter/material.dart';
import 'package:whackiest/model/product.dart';
import 'package:whackiest/services/api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Flutter Boilerplate')),
          body: FutureBuilder(future: Api.getProducts(), builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
            else{
              List<Product>data=snapshot.data;
              return ListView.builder(itemCount: data.length, itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text("${data[index].name}"),subtitle: Text("${data[index].price}"),leading: Image.network("${data[index].image}"),);
              },);
            }
          }),
        ),
      );
}
