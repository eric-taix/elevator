part of elevator;


/**
 * This strategy just move the elevator without opening the door !
 * 
 * Move UP until it reach heaven and then mode DOWN until it reach ground without taking care of stops
 */
class StupidOmnibusStrategy implements ElevatorStrategy {
  
  List<Stop> _stops = new List();
  
  void addOutgoingStop(Stop stop) {
    _stops.add(stop);
  }
  
  bool acceptIncomingCall(ElevatorModel model, Call call) {
    _stops.add(new Stop.fromCall(call));
    return true;
  }
  void reset() => _stops.clear();
  
  ElevatorCommand nextCommand(ElevatorModel model) => needOppositeDirection(model) ? new ElevatorCommand.fromDirection(model.direction.not()) : new ElevatorCommand.fromDirection(model.direction);
}


/**
 * This strategy is the same as the stupid one but stops everywhere someone is waiting
 */
class OmnibusStrategy extends StupidOmnibusStrategy {
  
  ElevatorCommand nextCommand(ElevatorModel model) {
    // First verify if there's someone here who's waiting
    if (_stops.any((_) => needToStop(_, model.floor))) {
      _stops.removeWhere((_) => needToStop(_, model.floor));
      // And open the door only if it's closed
      if (!model.doorOpen)
        return OPEN_COMMAND;
    }
    
    // If the door is open then close it before any other command
    if (model.doorOpen) return CLOSE_COMMAND;
    
    // Play the inherited command strategy
    return super.nextCommand(model);
  }
}


/**
 * This strategy is the same as the Omnibus one but reverse direction as soon as possible
 */
class LazyOmnibusStrategy extends OmnibusStrategy {
  
  bool acceptIncomingCall(ElevatorModel model, Call call) {
    if (_stops.isEmpty) {
      return super.acceptIncomingCall(model, call);
    }
    else if (call.direction == _stops.first.direction) {

      int dir = _stops.first.direction == Direction.UP ? 1 : -1;
      // Get the 'highest' (according to the direction) between existing stops and elevator
//      Stop newStop = new Stop(model.floor, model.floor, call.direction);
      Stop max = _stops.reduce((s1,s2) => (s1.stop - s2.stop) * dir > 0 ? s2 : s1);
      if (_after(model, max.stop, max.direction) && !_after(model, call.atFloor, max.direction)) return false;
      return super.acceptIncomingCall(model, call);
//      if ((call.atFloor - max.stop) * dir >= 0) return super.acceptIncomingCall(model, call);
    }
    return false;
  }
  
  bool _after(ElevatorModel model, int floor, Direction direction) {
    int dir = direction == Direction.UP ? 1 : -1;
    return (floor - model.floor) * dir >= 0 ? true : false;
  }

}
