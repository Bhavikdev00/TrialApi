import 'package:mongo_dart/mongo_dart.dart';

import '../models/user_model.dart';

class RegisterUserService{
  late DbCollection collection;


  RegisterUserService(Db db) {
    collection = db.collection('users');

  }

  Future addUser(User user) async {
    final res= await collection.insert(user.toMap());

    return res;
  }



  Future<bool> isEmailUnique(String email) async {
    final result = await collection.findOne(where.eq('email', email));
    return result == null;
  }

  Future<bool> isPhoneNumberUnique(String phoneNumber) async {
    final result =
    await collection.findOne(where.eq('phoneNumber', phoneNumber));
    return result == null;
  }

  Future<User?> getUserByEmail(String email) async {
    final result = await collection.findOne(where.eq('email', email));
    return result != null ? User.fromMap(result) : null;
  }

  Future<User?> getUserByPhoneNumber(String phoneNumber) async {
    final result =
    await collection.findOne(where.eq('phoneNumber', phoneNumber));
    return result != null ? User.fromMap(result) : null;
  }




}