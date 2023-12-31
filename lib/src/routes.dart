import 'package:my_server/src/controllers/otp_controller.dart';
import 'package:my_server/src/controllers/register_user_controller.dart';
import 'package:shelf_router/shelf_router.dart';

Router getApiRouter() {
  final router = Router();

  final registerUserController = RegisterUserController();
  final otpController=OtpController();
  router.mount('/api/auth', registerUserController.router);
  router.mount('/api/auth', otpController.router);

  return router;
}