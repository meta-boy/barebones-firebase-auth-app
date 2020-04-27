import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageUploader extends StatefulWidget {
  final String uid;

  const ImageUploader({Key key, this.uid}) : super(key: key);
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File _image;
  List<String> imageUrl = [];

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    print(basename(_image.path));
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("${widget.uid}/${basename(_image.path)}");
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        imageUrl.add(fileURL);
        _image = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image != null ? Image.asset(_image.path) : Container(),
                  _image == null
                      ? RaisedButton(
                          child: Text('Choose File'),
                          onPressed: chooseFile,
                          color: Colors.cyan,
                        )
                      : Container(),
                  _image != null
                      ? RaisedButton(
                          child: Text('Upload File'),
                          onPressed: uploadFile,
                          color: Colors.cyan,
                        )
                      : Container(),
                ],
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return Image.network(imageUrl[index]);
              }, childCount: imageUrl.length),
            )
          ],
        ),
      ),
    );
  }
}
