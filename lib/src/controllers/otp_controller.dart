


import 'dart:convert';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:my_server/db.dart';
import 'package:my_server/src/models/otp_model.dart';
import 'package:my_server/src/services/otp_service.dart';
import 'package:my_server/src/services/register_user_service.dart';
import 'package:otp/otp.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class OtpController{
  Router get router{
    Router router=Router();

    router.post('/verifyEmail/', _verifyEmail);
    router.post('/verifyOtp/', _verifyOtp);
    return router;
  }


  ///Send Otp to Email
  Future<Response> _verifyEmail(Request request) async{

    final db = MongoDB('mongodb://localhost:27017/my_database');
    await db.openConnection();
    final otpService = OtpService(db.db);

    try{

      final requestBody = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(requestBody);

      String  userEmail= data["email"];
      String secret = 'asdnasjdnasjdnasjdasdnasjdnajsdndnasdjnasd';
      String otp = OTP.generateTOTPCode(secret, DateTime.now().millisecondsSinceEpoch).toString();

      await _sendEmail(otp: otp,userEmail: userEmail, otpService: otpService );




      return Response.ok("Otp Send Successfully");



    }catch(e){
      print(e.toString());
      return Response(500,body: "Internal Server Error");
    }


  }
  Future<void> _sendEmail({required String userEmail, required String otp ,required OtpService otpService}) async {
    // Replace these values with your own SMTP server configuration
    final smtpServer = gmail('zsp.bhavik@gmail.com', 'iwvu vtof svpj ubfc');

    // Create the email message
    final message = Message()
      ..from = Address('zsp.bhavik@gmail.com', 'Help Harbor')
      ..recipients.add(userEmail)
      ..subject = 'Email Verification OTP'
      ..html = '''
     <!DOCTYPE html>
<html>

<head>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #f4f4f4;
      color: #333;
      margin: 0;
      padding: 0;
      text-align: center;
    }

    .container {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background-color: #fff;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    h2 {
      color: #007bff;
    }

    .verification-code {
      color: #007bff;
      font-size: 36px;
      margin: 20px 0;
    }

    .expire-message {
      color: #dc3545;
      margin-top: 10px;
    }

    .notice {
      color: #28a745;
      margin-top: 10px;
    }

    .support-info {
      margin-top: 20px;
    }

    .contact-link {
      color: #007bff;
      text-decoration: none;
      font-weight: bold;
    }
  </style>
</head>

<body>
  <div class="container">
    <h2>Help Harbor Email Verification</h2>
    <p>Dear User,</p>
    <p>Your verification code for Help Harbor is:</p>
    <h1 class="verification-code">$otp</h1>
    <p class="expire-message">This code will expire in 5 minutes.</p>
    <p class="notice">Please do not share this code with anyone for security reasons.</p>
    <p>If you have any questions or need assistance, feel free to reach out to our support team.</p>
    <div class="support-info">
      <p>Contact us at: <a class="contact-link" href="mailto:support@helpharbor.com">support@helpharbor.com</a></p>
    </div>
    <p>Thank you for choosing Help Harbor!</p>
  </div>
</body>

</html>

    ''';

    try {
      final sendReport = await send(message, smtpServer);
      final otpData= OtpModel(otp: otp,email: userEmail,createdAt: DateTime.now());
      await  otpService.addOtp(otpData.toMap());
      print('Message sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Failed to send the email: $e');
    }
  }


  ///Verify Otp


  Future<Response> _verifyOtp(Request request)async{
    final db = MongoDB('mongodb://localhost:27017/my_database');
    await db.openConnection();
    final otpService = OtpService(db.db);


    try{
      final requestBody = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(requestBody);
      final isOtpValid=await otpService.verifyOtp(data);
      if(!isOtpValid){
        otpService.deleteOtpData(data);
        return Response.ok("Otp Verified");
      }else{
        return Response.ok("Otp is invalid");
      }
    }catch(e){
      return Response.internalServerError(body: "Internal server Error");
    }
  }

}