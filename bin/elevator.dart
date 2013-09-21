import 'dart:io';
import 'dart:json' as JSON;

main() {
  var port = int.parse(Platform.environment['PORT']);
  HttpServer.bind('0.0.0.0', port).then((HttpServer server) {
    print('Server started on port: ${port}');
    server.listen((HttpRequest request) {
      var resp = JSON.stringify({
        'Name': 'Taix',
        'FirstName': 'Eric',
        'Environment': Platform.environment}
      );
      request.response..headers.set(HttpHeaders.CONTENT_TYPE, 'application/json')
                      ..write(resp)
                      ..close();
    });
  });
}