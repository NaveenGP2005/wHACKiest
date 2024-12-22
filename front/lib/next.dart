import 'package:flutter/material.dart';
import 'package:whackiest/services/api.dart';
import 'package:whackiest/model/product.dart';
import 'package:get/get.dart';
import 'package:whackiest/controller/controller.dart';
import 'package:whackiest/model/msg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Declare the controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        home: MyAppHome(
          nameController: nameController,
          priceController: priceController,
          imageController: imageController,
        ),
      );
}

class MyAppHome extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController imageController;

  // Constructor to accept the controllers
  MyAppHome({
    required this.nameController,
    required this.priceController,
    required this.imageController,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Product List",
            style: TextStyle(
              fontFamily: 'head',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: Api.getProducts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<Product> data = snapshot.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(data[index].name ?? '',
                        style: TextStyle(fontFamily: "bdy")),
                    subtitle: Text("\$${data[index].price}",
                        style: TextStyle(fontFamily: "bdy")),
                    leading: Image.network(data[index].image ?? ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: data[index]),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductPage(
                      nameController: nameController,
                      priceController: priceController,
                      imageController: imageController,
                    ),
                  ),
                );
              },
              heroTag: 'createBtn',
              child: Icon(Icons.add),
              tooltip: 'Create Product',
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(sellerName: ''),
                  ),
                );
              },
              heroTag: 'chatBtn',
              child: Icon(Icons.chat),
              tooltip: 'Chat',
            ),
          ],
        ),
      );
}

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name ?? 'Product Details',
          style: TextStyle(
            fontFamily: "head",
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.image != null)
              Center(
                child: Image.network(product.image!),
              ),
            const SizedBox(height: 20),
            Text(
              product.name ?? 'No Name',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "bdy"),
            ),
            const SizedBox(height: 10),
            Text(
              "\$${product.price}",
              style: const TextStyle(
                  fontSize: 20, color: Colors.teal, fontFamily: "bdy"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showBuyDialog(context, product);
              },
              child: const Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBuyDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buy ${product.name}'),
          content: Text('What would you like to do?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      sellerName: product.name ?? 'Unknown',
                    ),
                  ),
                );
              },
              child: Text('Contact Seller'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showCourierAddressDialog(context);
              },
              child: Text('Courier'),
            ),
          ],
        );
      },
    );
  }

  void _showCourierAddressDialog(BuildContext context) {
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Shipping Address'),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(hintText: "Enter your address"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                String address = addressController.text;
                if (address.isNotEmpty) {
                  print("Courier address: $address");
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without action
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class AddProductPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController imageController;

  AddProductPage({
    required this.nameController,
    required this.priceController,
    required this.imageController,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Product",
            style: TextStyle(
              fontFamily: "head",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.red], // Gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  var price = priceController.text.isNotEmpty
                      ? priceController.text
                      : "0";

                  if (double.tryParse(price) == null) {
                    print("Invalid price entered");
                    return;
                  }

                  var data = {
                    "name": nameController.text,
                    "price": price,
                    "image": imageController.text,
                  };

                  Api.addProduct(data);
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      );
}

class ChatPage extends StatefulWidget {
  final String sellerName;

  const ChatPage({required this.sellerName, super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController msgInputController = TextEditingController();
  late IO.Socket socket;
  final chatController controller = Get.put(chatController());

  @override
  void initState() {
    super.initState();

    // Clear previous chat messages to avoid duplication
    controller.chatMessages.clear();

    socket = IO.io(
      'http://localhost:8080',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();
    setupSocketListeners(socket);
    socket.emit('get-all-messages');
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void sendMessage(String text) {
    DateTime currentTimestamp = DateTime.now();

    var msgJson = {
      "message": text,
      "sentbyMe": socket.id,
      "timestamp": currentTimestamp.toIso8601String(),
    };

    socket.emit('message', msgJson);
    controller.chatMessages.add(Message.fromJson(msgJson));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Chat'), // Changed heading here
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                return Text(
                  'Users online: ${controller.connectedUsers.value}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
            ),
          ),
          Expanded(
            flex: 8,
            child: Obx(() => ListView.builder(
                  itemCount: controller.chatMessages.length,
                  itemBuilder: (context, index) {
                    var currentItem = controller.chatMessages[index];
                    return MsgItem(
                      sentbyMe: currentItem.sentbyMe == socket.id,
                      msg: currentItem.message,
                      timestamp: currentItem.timestamp,
                    );
                  },
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgInputController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            if (msgInputController.text.isNotEmpty) {
                              sendMessage(msgInputController.text);
                              msgInputController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void setupSocketListeners(IO.Socket socket) {
  socket.on("message-received", (data) {
    print(data);
    Get.find<chatController>().chatMessages.add(Message.fromJson(data));
  });

  socket.on("connected", (data) {
    print('Connected users: $data');
    Get.find<chatController>().connectedUsers.value = data;
  });

  socket.on("all-messages", (messages) {
    messages.forEach((msg) {
      Get.find<chatController>().chatMessages.add(Message.fromJson(msg));
    });
  });
}

class MsgItem extends StatelessWidget {
  const MsgItem({
    Key? key,
    required this.sentbyMe,
    required this.msg,
    required this.timestamp,
  }) : super(key: key);

  final bool sentbyMe;
  final String msg;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        "${timestamp.hour}:${timestamp.minute < 10 ? '0${timestamp.minute}' : timestamp.minute}";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      alignment: sentbyMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: sentbyMe ? Colors.blue.shade100 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 10),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
