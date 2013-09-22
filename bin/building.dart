library elevator;

import 'dart:io';
import 'dart:collection';

import 'package:route/server.dart';

part 'urls.dart';
part 'elevator.dart';

Building building = new Building();

main() {
  var port = Platform.environment['PORT'] != null ? int.parse(Platform.environment['PORT']) : 8081;
  
  HttpServer.bind('0.0.0.0', port).then(((HttpServer server) {
    var router = new Router(server)
    ..serve(resetUrl, method: 'GET').listen(building.resetHandler)
    ..serve(nextCommandUrl, method: 'GET').listen(building.nextCommandHandler)
    ..serve(goUrl, method: 'GET').listen(building.goHandler)
    ..serve(userHasEnteredUrl, method: 'GET').listen(building.userHasEntered)
    ..serve(userHasExitedUrl, method: 'GET').listen(building.userHasExited)
    ..serve(callUrl, method: 'GET').listen(building.callHandler);
  }));
  
}

/**
 * An enumeration for direction (UP or DOWN)
 */
class Direction {
  static const UP = const Direction._('UP');
  static const DOWN = const Direction._('DOWN');

  final String value;

  const Direction._(this.value);
  
  /**
   * Return the opposite direction
   */
  Direction not() => this == UP ? DOWN : UP;
  
  String toString() => value;
}

/**
 *  A incoming call
 */
class Call {
  int _atFloor;
  Direction _direction;
  
  Call(this._atFloor, this._direction);
  
  int get atFloor => _atFloor;
  Direction get direction => _direction;
}

/**
 * This class manages incoming calls and dipatches them to the right elevator
 */
class Building {
  
  Elevator _elevator = new Elevator();
  // Incoming calls
  List<Call> _calls = new List();
  
  
  /**
   * Write a reponse and close the stream
   */
  _writeResponse(HttpRequest req, [String response = ""]) {
    req.response..writeln(response)..close();
  }
  
  ///
  /// A new incoming call
  /// 
  callHandler(HttpRequest req) {
    int floor = int.parse(req.uri.queryParameters['atFloor']);
    Direction direction = req.uri.queryParameters['to'] == 'UP' ? Direction.UP : Direction.DOWN;
    Call incomingCall = new Call(floor, direction);
    _calls.add(incomingCall);
    _elevator.call(floor, direction);
    print('Call at floor ${floor} ${direction} / Elevator: ${_elevator}'); 
    _writeResponse(req);
  }
  
  userHasExited(HttpRequest req) {
    _writeResponse(req);
  }

  userHasEntered(HttpRequest req) {
    _writeResponse(req);
  }

  goHandler(HttpRequest req) {
    int floor = int.parse(req.uri.queryParameters['floorToGo']);
    _elevator.go(floor);
    print('Go to floor ${floor} received / Elevator: ${_elevator}'); 
    _writeResponse(req);
  }

  resetHandler(HttpRequest req) {
    _elevator.reset();
    print('Reset received  / Elevator: ${_elevator}');
    _writeResponse(req);
  }

  nextCommandHandler(HttpRequest req) {
    String command = _elevator.nextCommand();
    print('Next command returned: ${command} Elevator: ${_elevator}');
    _writeResponse(req, command);
  }
}


