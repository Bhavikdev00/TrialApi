import 'package:mongo_dart/mongo_dart.dart';

class OtpService{

  late DbCollection otpCollection;
  OtpService(Db db) {

    otpCollection = db.collection('otp');
  }

  Future addOtp(Map<String,dynamic> otpData) async {
    final res= await otpCollection.insert(otpData);

    return res;
  }
  Future verifyOtp(Map<String,dynamic> otpData) async {
    final result = await otpCollection.findOne(where.eq('email', otpData['email']).eq('otp', otpData['otp']));

    return result == null;
  }
  Future deleteOtpData(Map<String,dynamic> data)async{
    final email=data['email'];
    
    otpCollection.deleteOne(where.eq('email', email));
    
    
  }
}