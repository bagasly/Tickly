import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseMethods {
  Future addCategory(Map<String, dynamic> categoryInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('myday')
        .doc(id)
        .set(categoryInfoMap);
  }
}
