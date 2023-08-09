import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DBFirestore{
DBFirestore._();

static final DBFirestore _instance = DBFirestore._();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;


static FirebaseFirestore get(){
  return DBFirestore._instance._firestore;
}

}

class FBStorage{
  FBStorage._();

  static final FBStorage _instance = FBStorage._();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static FirebaseStorage get(){
    return FBStorage._instance._storage;
  }
}