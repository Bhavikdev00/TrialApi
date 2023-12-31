import 'dart:convert';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:my_server/db.dart';
import 'package:my_server/src/models/user_model.dart';
import 'package:my_server/src/services/register_user_service.dart';
import 'package:otp/otp.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class RegisterUserController {


  Router get router{
    Router router=Router();
    router.post('/registerUser/', _registerUser);
    return router;
  }






  Future<Response> _registerUser(Request request) async{
    final db = MongoDB('mongodb://localhost:27017/my_database');
    await db.openConnection();
    final registerUserService = RegisterUserService(db.db);

    try {
      final requestBody = await request.readAsString();
      final Map<String, dynamic> userData = jsonDecode(requestBody);

      final email = userData['email'];
      final phoneNumber = userData['phoneNumber'];

      // Check if email and phone number are unique
      final isEmailUnique = await registerUserService.isEmailUnique(email);
      final isPhoneNumberUnique =
      await registerUserService.isPhoneNumberUnique(phoneNumber);

      if (!isEmailUnique) {
        return Response(400, body: 'Email is already registered.');
      }

      if (!isPhoneNumberUnique) {
        return Response(400, body: 'Phone number is already registered.');
      }

      // Generate a unique userId (you can use a library for this)
      // final userId = 'unique_user_id';

      final newUser = User(
     
      name:   userData['name'],
     email:    email,
       phoneNumber:  phoneNumber,
       profile:  userData['profile'], password: '', id: '', role: '', createdAt: DateTime.now(),
      );

      await  registerUserService.addUser(newUser);
      final res=newUser.toMap();
      res.addAll({"status":"Success","message":"User Registered Successfully"});
      print(res);
      await db.closeConnection();

      return Response.ok( jsonEncode(res));
    } catch (e) {
      print(e.toString());
      return Response(500, body: 'Internal server error');
    }
  }

}