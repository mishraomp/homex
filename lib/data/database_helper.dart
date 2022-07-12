import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;

import 'package:homex/constants/application_constants.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final String createTableItemInfo =
      "${ApplicationConstants.createTable} ${ApplicationConstants.itemInfo} (id INTEGER PRIMARY KEY, userName TEXT, password TEXT, firstName TEXT,lastName TEXT, phoneNumber INTEGER)";

  Future<Database> get db async {
    return initDb();
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "home_index.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    try {
      await db.execute(createTableItemInfo);
    } catch (error) {
      log('Error occurred: $error');
    }
    log("Created tables");
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.isNotEmpty ? true : false;
  }
}
