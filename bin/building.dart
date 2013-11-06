library elevator;

import 'dart:io';
import 'dart:async';
import 'package:route/server.dart';
import 'package:route/pattern.dart';

part 'urls.dart';
part 'elevator.dart';

part 'strategies/omnibus_strategy.dart';

part 'strategies/elevator_strategy.dart';
part 'elevator_command.dart';
part 'direction.dart';


//--------------- Useful functions (some are generic, others not) -----------

/// A generic 'AND' predicate function
and(Iterable predicates) => (e) => predicates.every((p) => p(e));

/// Is the stop at the current floor ?
bool sameFloor(Floorable floor, int stop) => floor.floor == stop;

/// Is the [GoalFloor] at the same floor as the elevator
sameFloorAsElevator(elevator) => (Floorable floor) => sameFloor(floor, elevator.floor);

/// Do we reach the minimum or maximum floor according to our direction ?
bool needOppositeDirection(ElevatorModel model) => (model.direction == Direction.UP && model.isHeaven) || (model.direction == Direction.DOWN && model.isGround);

/// Is the call accepted by the elevator
acceptCall(elevator) => (Call call) => elevator.acceptCall(call);

//----------------------------------------------------------------------------

Building building = new Building(20);

main() {
  var port = Platform.environment['PORT'] != null ? int.parse(Platform.environment['PORT']) : 8081;
  
  HttpServer.bind('0.0.0.0', port).then(((HttpServer server) {
    var router = new Router(server)
    ..filter(matchAny(allUrls), log)
    ..serve(resetUrl, method: 'GET').listen(building.resetHandler)
    ..serve(nextCommandUrl, method: 'GET').listen(building.nextCommandHandler)
    ..serve(goUrl, method: 'GET').listen(building.goHandler)
    ..serve(userHasEnteredUrl, method: 'GET').listen(building.userHasEntered)
    ..serve(userHasExitedUrl, method: 'GET').listen(building.userHasExited)
    ..serve(callUrl, method: 'GET').listen(building.callHandler);
  }));
  
}

Future<bool> log(HttpRequest req) {
  print("${req.uri.path}/${req.uri.query}");
  return new Future.value(true);
}


/**
 * This class manages incoming calls and dipatches them to the right elevator
 */
class Building {
  
  int _maxFloor;
  Elevator _elevator;
  
  // Incoming calls
  List<Call> _calls = new List();
  
  Building(this._maxFloor) {
    _elevator = new Elevator(this._maxFloor, new OmnibusStrategy());
  }
  
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
    _calls.add(new Call(floor, direction));
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
    _elevator.goTo(floor);
    print('Go to floor ${floor} received / Elevator: ${_elevator}'); 
    _writeResponse(req);
  }

  resetHandler(HttpRequest req) {
    _elevator.reset();
    print('Reset received: ${req.uri.path}');
    _writeResponse(req);
  }

  nextCommandHandler(HttpRequest req) {
    // Verify if the elevator wants to accept new incoming call which are at the same floor as the elevator
    _calls.removeWhere(acceptCall(_elevator));
    // Get the command and apply it
    ElevatorCommand command = _elevator.nextCommand();
    String commandStr = command.apply(_elevator);
    print("=> ${commandStr}");

    _writeResponse(req, commandStr);
  }
}


