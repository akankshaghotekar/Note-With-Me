import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  // Singleton
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  //table note
  static final String TABLE_NOTE = "note";
  static final String COLUMN_NOTE_SNO = "s_no";
  static final String COLUMN_NOTE_TITLE = "title";
  static final String COLUMN_NOTE_DESC = "desc";

  Database? myDb;

  /// db Open (path -> if exists open else create )
  Future<Database> getDB() async {
    /*if (myDb != null) {
      return myDb!;
    } else {
      myDb = await openDB();
      return myDb!;
    } */
    myDb = myDb ?? await openDB();
    return myDb!;
  }

  Future<Database> openDB() async {
    //from path_provider package
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, "noteDB.db"); // join from path package

    // from sqflite package
    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        /// create all your table here
        db.execute(
          "create table $TABLE_NOTE ($COLUMN_NOTE_SNO integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text)",
        );
      },
      version: 1,
    );
  }

  /// all queries
  /// insertion
  Future<bool> addNote({required String mTitle, required String mDesc}) async {
    var db = await getDB();

    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESC: mDesc,
    });
    return rowsEffected > 0;
  }

  /// fetch/reading all notes
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();

    /// this is nothing but select * from table
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE);

    return mData;
  }

  /// update
  Future<bool> updateNote({
    required String title,
    required String desc,
    required int sno,
  }) async {
    // update table set title = 'new tittle', desc = 'new desc'
    var db = await getDB();
    int rowsEffected = await db.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: title,
      COLUMN_NOTE_DESC: desc,
    }, where: "$COLUMN_NOTE_SNO = $sno");
    return rowsEffected > 0;
  }

  /// delete
  Future<bool> deleteNote({required int sno}) async {
    var db = await getDB();
    int rowsEffected = await db.delete(
      TABLE_NOTE,
      where: "$COLUMN_NOTE_SNO = ?",
      whereArgs: ['$sno'],
    );
    return rowsEffected > 0;
  }
}
