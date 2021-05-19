import 'package:flutter/material.dart';
import 'package:midtermstiw2044_myshop/newproduct.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String titlecenter = "Loading...";
  List _listproduct;

  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        centerTitle: true,
        leading: new Icon(Icons.shopping_bag_outlined),
        title: Text(
          "My Shop",
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
          child: Column(
        children: [
          _listproduct == null
              ? Flexible(child: Center(child: Text(titlecenter)))
              : Flexible(
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: GridView.count(
                              crossAxisCount: 2,
                              children:
                                  List.generate(_listproduct.length, (index) {
                                return Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Card(
                                        child: SingleChildScrollView(
                                            child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://lowtancqx.com/s269957/myshop/images/${_listproduct[index]['id']}.png",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                new Transform.scale(
                                                    scale: 1,
                                                    child:
                                                        CircularProgressIndicator()),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text("Product Name:",
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              SizedBox(height: 30),
                                              GestureDetector(
                                                child: Text(
                                                    _listproduct[index]
                                                        ["prname"],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Colors.cyan[900])),
                                              ),
                                            ]),
                                      ],
                                    ))));
                              })))
                    ],
                  )),
                ),
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NewProduct()));
          });
        },
      ),
    );
  }

  void _loadProducts() {
    http.post(
        Uri.parse('https://lowtancqx.com/s269957/myshop/php/loadproducts.php'),
        body: {}).then((response) {
      if (response.body == "nodata") {
        titlecenter = "Product not available";
      } else {
        var jsondata = json.decode(response.body);
        _listproduct = jsondata["products"];

        setState(() {
          print(_listproduct);
        });
      }
    });
  }
}
