import 'package:crud_sqlite/model/note.dart';
import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final Note note;
  Input(this.note);
  @override
  _InputState createState() => _InputState(this.note);
}

class _InputState extends State<Input> {
  Note note;
  _InputState(this.note);

  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //! Kondisi note tidak null/kosong
    if (note != null) {
      titleController.text = note.title;
      descController.text = note.desc;
    }

    //! Rubah
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              if (note == null) {
                note = Note(titleController.text, descController.text);
              } else {
                //! Ubah data
                note.titleSet = titleController.text;
                note.descSet = descController.text;
              }
              Navigator.of(context).pop(note);
            }),
        title: note == null ? Text('Add') : Text('Edit'),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Title' ,hintStyle: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: descController,
              maxLines: 15,
              maxLength: 300,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
