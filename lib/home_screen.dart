import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    loadModel().then((value){
      setState(() {

      });
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);

  }
  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);

  }
  detectImage(File image) async {
    _loading = true;
    var output = await Tflite.runModelOnImage(path: image.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5
    );
    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(model: 'assets/model_cat_dog.tflite', labels: "assets/model_cat_dog.txt");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Text("Nagas Title"),
            SizedBox(height: 5,),
            Text("Cats and Dogs"),
            Center( child: _loading ? Container(
              child: Column(
                children: [
                  Image.asset('assets/cat_dog_icon.png'),
                  SizedBox(height: 50,)
                ],
              ),
            ) : Column(
              children: [
                Container(
                  height: 250,
                  child: Image.file(_image),
                ),
                SizedBox(height: 50,),
                _output != null ? Text('${_output[0]['label']}'): Container(),
                SizedBox(height: 10,)
              ],

            )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      pickImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.yellow, borderRadius: BorderRadius.circular(6)
                      ),
                      child: Text('Capture a photo', style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                      ),),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      pickGalleryImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.yellow, borderRadius: BorderRadius.circular(6)
                      ),
                      child: Text('Select Photo', style: TextStyle(
                          color: Colors.white,
                          fontSize: 25
                      ),),
                    ),
                  )
                ],
              ),
            )

          ]
        ),
      ),
    );
  }
}
