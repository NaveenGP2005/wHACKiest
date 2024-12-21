import 'package:flutter/material.dart';
import 'package:whackiest/model/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(product.name ?? 'Product Details')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(product.image ?? '',
                  height: 200, width: double.infinity, fit: BoxFit.cover),
              SizedBox(height: 20),
              Text(
                product.name ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text("\$${product.price}", style: TextStyle(fontSize: 20)),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  showBuyOptions(context);
                },
                child: Text('Buy'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      );

  void showBuyOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an Option'),
          content: Text('How would you like to proceed?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Contact seller directly.')),
                );
              },
              child: Text('Contact Seller Directly'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the first dialog
                showAddressDialog(context);
              },
              child: Text('Place Courier'),
            ),
          ],
        );
      },
    );
  }

  void showAddressDialog(BuildContext context) {
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Address'),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(hintText: 'Your address'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                if (addressController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Courier placed to address: ${addressController.text}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Address cannot be empty.')),
                  );
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
