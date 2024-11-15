//
//
//
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class EncryptedStorage {
//
//   FlutterSecureStorage? _storage;
//
//   Future<void> initialize() async {
//     _storage =  const FlutterSecureStorage();
//   }
//
//
//   static final EncryptedStorage _instance = EncryptedStorage._internal();
//
//   factory EncryptedStorage(){
//     return _instance;
//   }
//
//   EncryptedStorage._internal();
//
//   Future<void> saveData(String key, String value) async {
//     await _storage?.write(key: key, value: value);
//   }
//
//   Future<String?> readData(String key) async {
//     return await _storage?.read(key: key);
//   }
//
//   Future<void> deleteData(String key) async {
//     await _storage?.delete(key: key);
//   }
// }


import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptedStorage {
  static final EncryptedStorage _instance = EncryptedStorage._internal();

  factory EncryptedStorage() => _instance;

  EncryptedStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> saveBool(String key, bool value) async {
    String stringValue = value.toString(); // Convert boolean to string
    await _storage.write(key: key, value: stringValue);
  }

  Future<bool?> readBool(String key) async {
    String? stringValue = await _storage.read(key: key);
    if (stringValue != null) {
      return stringValue == 'true'; // Convert string to boolean
    } else {
      return null;
    }
  }

  Future<void> deleteBool(String key) async {
    await _storage.delete(key: key);
  }

// Clear all data stored in FlutterSecureStorage
  Future<void> clearSecureStorage() async {
    await _storage.deleteAll();
  }


}
