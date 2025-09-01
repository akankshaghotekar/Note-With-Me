import 'package:flutter/material.dart';
import 'package:note_with_me/data/local/db_helper.dart';
import 'package:note_with_me/domain/constants/ui_helper.dart';

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
      backgroundColor: UiHelper.appBgColor,
      // all notes viewed here
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your notes are in my backpack',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'storyscript',
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: UiHelper.headlineColor,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/homescreen_panda_img-removebg-preview.png',

              // Adjust height as needed
            ),
          ),
          Positioned(
            top: 350,
            right: 15,
            child: Container(
              height: 600,
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 2),
                ],
              ),

              child: allNotes.isEmpty
                  ? Center(child: Text("No Notes Yet!"))
                  : ListView.builder(
                      itemCount: allNotes.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          leading: Text("${index + 1}"), // else use .toString()
                          title: Text(
                            allNotes[index][DBHelper.COLUMN_NOTE_TITLE],
                          ),
                          subtitle: Text(
                            allNotes[index][DBHelper.COLUMN_NOTE_DESC],
                          ),
                          trailing: SizedBox(
                            width: 60,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // update note
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        titleController.text =
                                            allNotes[index][DBHelper
                                                .COLUMN_NOTE_TITLE];
                                        descController.text =
                                            allNotes[index][DBHelper
                                                .COLUMN_NOTE_DESC];
                                        return getBottomSheetWidget(
                                          isUpdate: true,
                                          sno:
                                              allNotes[index][DBHelper
                                                  .COLUMN_NOTE_SNO],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Color(0XFF594E73),
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () async {
                                    bool check = await dbRef!.deleteNote(
                                      sno:
                                          allNotes[index][DBHelper
                                              .COLUMN_NOTE_SNO],
                                    );
                                    if (check) {
                                      getNotes();
                                    }
                                  },
                                  child: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // note to be added from here
          showModalBottomSheet(
            context: context,
            builder: (context) {
              titleController.clear();
              descController.clear();
              return getBottomSheetWidget();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    return Container(
      padding: EdgeInsets.all(11),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            isUpdate ? 'Update Note' : "Add Note",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      bool check = isUpdate
                          ? await dbRef!.updateNote(
                              title: title,
                              desc: desc,
                              sno: sno,
                            )
                          : await dbRef!.addNote(mTitle: title, mDesc: desc);
                      if (check) {
                        getNotes();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("*Please fill all the required blanks"),
                        ),
                      );
                    }
                    titleController.clear();
                    descController.clear();
                    Navigator.pop(context);
                  },
                  child: Text(isUpdate ? "Update Note" : "Add Note"),
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
  }
}
