
import 'package:my_server/src/routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() {
  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(getApiRouter());
  shelf_io.serve(handler, 'localhost', 8080).then((server) {
    print('Server is running on port ${server.port}');
  });
}


