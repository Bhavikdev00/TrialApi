import 'package:mongo_dart/mongo_dart.dart';

class MongoDB {
  late Db _db;

  MongoDB(String uri) {
    _db = Db(uri);
  }

  Future<void> openConnection() async {
    await _db.open();
  }

  Db get db => _db;

  Future<void> closeConnection() async {
    await _db.close();
  }
}