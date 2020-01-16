import 'package:crud_sqlite/helper/dbhelper.dart';
import 'package:crud_sqlite/model/note.dart';
import 'package:crud_sqlite/ui/input.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Note> noteList;

  Future<Note> navigateToInput(context, note) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Input(note),
      ),
    );
    return result;
  }

  ListView createListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
              title: Text(this.noteList[index].title),
              subtitle: Text(this.noteList[index].desc),
              onTap: () async {
                var note = await navigateToInput(context, this.noteList[index]);
                if (note != null) editnote(note);
              },
              onLongPress: () async {
                deletenote(this.noteList[index]);
              }),
        );
      },
    );
  }

  void addnote(Note object) async {
    int result = await dbHelper.insert(object);
    if (result > 0) updateListView();
  }

  void editnote(Note object) async {
    int result = await dbHelper.update(object);
    if (result > 0) updateListView();
  }

  void deletenote(Note object) async {
    int result = await dbHelper.delete(object.id);
    if (result > 0) updateListView();
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dbHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Note list'),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: createListView(),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Builder(
                    builder: (context) => FlatButton(
                      child: Text(
                        'Create Note',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        var note = await navigateToInput(context, null);
                        if ('${note.title}'.isEmpty && '${note.desc}'.isEmpty) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Empty note deleted'),
                          ));
                        } else {
                          addnote(note);
                        }
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
