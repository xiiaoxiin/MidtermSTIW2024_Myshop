import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

void main() => runApp(NewProduct());

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final TextEditingController _prnamecontroller = TextEditingController();
  final TextEditingController _prpricecontroller = TextEditingController();
  final TextEditingController _prquantitycontroller = TextEditingController();
  final TextEditingController _prtypecontroller = TextEditingController();


  String _prname = "";
  String _prtype = "";
  String _prprice = "";
  String _prquantity = "";
 
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/camera.png';

  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('New Product Update'),
        backgroundColor: Colors.green,
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () => {_onPictureSelection()},
                        child: Container(
                          height: screenHeight / 3.2,
                          width: screenWidth / 1.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              width: 3.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    5.0) //         <--- border radius here
                                ),
                          ),
                        )),
                    SizedBox(height: 5),
                    Text("Click image to take product picture",
                        style: TextStyle(fontSize: 10.0, color: Colors.black)),
                    SizedBox(height: 5),
                    TextField(
                        controller: _prnamecontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: 'Product Name',
                            icon: Icon(Icons.fastfood, color: Colors.greenAccent))),
                    TextField(
                        controller: _prtypecontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: 'Product Type',
                            icon: Icon(Icons.format_list_numbered,color: Colors.amber))),
                    TextField(
                        controller: _prpricecontroller,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: 'Product Price',
                            icon: Icon(Icons.money, color: Colors.teal))),
                    TextField(
                        controller: _prquantitycontroller,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: 'Quantity Available',
                            icon: Icon(Icons.note_add_outlined,
                                color: Colors.lime))),

                    SizedBox(height: 15),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child:
                          Text('Add New Product', style: TextStyle(fontSize: 18)),
                      color: Colors.tealAccent[700],
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: newCakeDialog,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ))),
    );
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.lime[50],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                  SizedBox(height: 15),
                  // Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // children: [
                  Flexible(
                      child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minWidth: 100,
                    height: 50,
                    child: Text('Camera',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    //color: Color.fromRGBO(101, 255, 218, 50),
                    color: Colors.lime[100],
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: () => {Navigator.pop(context), _chooseCamera()},
                  )),
                  SizedBox(height: 10),
                  Flexible(
                      child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minWidth: 100,
                    height: 50,
                    child: Text('Gallery',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    //color: Color.fromRGBO(101, 255, 218, 50),
                    color: Colors.lime[100],
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: () => {
                      Navigator.pop(context),
                      _chooseGallery(),
                    },
                  )),
                  // ],
                  // ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _cropImage();
    setState(() {});
  }

  Future<void> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void newCakeDialog() {
    _prname = _prnamecontroller.text;
    _prtype = _prtypecontroller.text;
    _prprice = _prpricecontroller.text;
    _prquantity = _prquantitycontroller.text;


    if (_prname == "" &&
        _prtype == "" &&
        _prprice == "" &&
        _prquantity == "") {
      Fluttertoast.showToast(
          msg: "Fill all required fields",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Register new Cake? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure to add new recipe?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onAddCake();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onAddCake() {
    final dateTime = DateTime.now();
    _prname = _prnamecontroller.text;
    _prtype = _prtypecontroller.text;
    _prprice = _prpricecontroller.text;
    _prquantity = _prquantitycontroller.text;

    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post(Uri.parse("/s269957/myshop/php/newproduct.php"), body: {
      "prname": _prname,
      "prprice": _prprice,
      "prquantity": _prquantity,
      "encoded_string": base64Image,
      "imagename": _prname + "-${dateTime.microsecondsSinceEpoch}",
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.lightGreen,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.lightGreen,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
