import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;


 class FileService {
  String baseURL = 'https://jsonplaceholder.typicode.com';
  var directory = null;

  Future<String> get _localPath async {
   final directory = await getApplicationDocumentsDirectory();

   return directory.path;
  }

  Future<File> get _localFile async {
   final path = await _localPath;
   return File('$path/counter1.txt');
  }
  Future<File> get _localAdminFile async {
   final path = await _localPath;
   return File('$path/AdminBookings.txt');
  }

  Future<File> saveBUs(String BUsJSON) async {
   debugPrint(BUsJSON);
   final file = await _localFile;

   // Write the file
   return file.writeAsString('$BUsJSON');
  }
  Future<File> saveAdminBUs(String BUsJSON) async {
   final file = await _localAdminFile;
   return file.writeAsString('$BUsJSON');
  }
  Future<String> readBUs() async {
     try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();

      return contents;
     } catch (e) {
      // If encountering an error, return 0
      return  'err';
     }
  }
  Future<String> readRepeatingBUs() async {
   try {
    final file = await _localAdminFile;
    // Read the file
    String contents = await file.readAsString();

    return contents;
   } catch (e) {
    // If encountering an error, return 0
    return  'err';
   }
  }
}
