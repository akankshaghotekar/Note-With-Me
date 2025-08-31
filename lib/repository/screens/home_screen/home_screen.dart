import 'package:flutter/material.dart';
import 'package:note_with_me/data/local/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // controller

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;
  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes With Me")),
      // all notes viewed here
      body: allNotes.isEmpty
          ? Center(child: Text("No Notes Yet!"))
          : ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text(
                    "${allNotes[index][DBHelper.COLUMN_NOTE_SNO]}",
                  ), // else use .toString()
                  title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String errorMsg = "";
          // note to be added from here
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(11),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      "Add Note",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 21),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Enter title here",
                        label: Text("Title *"),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                    SizedBox(height: 21),
                    TextFormField(
                      controller: descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Enter description here",
                        label: Text("Des *"),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                    SizedBox(height: 21),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(11),
                              ),
                              side: BorderSide(width: 1, color: Colors.black),
                            ),
                            onPressed: () async {
                              var title = titleController.text.trim();
                              var desc = descController.text.trim();
                              if (title.isNotEmpty && desc.isNotEmpty) {
                                bool check = await dbRef!.addNote(
                                  mTitle: title,
                                  mDesc: desc,
                                );
                                if (check) {
                                  getNotes();
                                }
                              } else {
                                errorMsg =
                                    "*Please fill all the required blanks";
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMsg)),
                                );
                              }
                              titleController.clear();
                              descController.clear();
                              Navigator.pop(context);
                            },
                            child: Text("Add Note"),
                          ),
                        ),
                        SizedBox(width: 11),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(11),
                              ),
                              side: BorderSide(width: 1, color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
