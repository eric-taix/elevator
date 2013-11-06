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
    if (_stops.any(sameFloorAsElevator(model))) {
      _stops.removeWhere(sameFloorAsElevator(model));
      // And open the door only if it's closed
      if (!model.doorOpen)
        return OPEN_COMMAND;
    }
    
    // If the door is open then close it before any other command
    if (model.doorOpen) return CLOSE_COMMAND;
    
    // Play the inherited command strategy
    return _defaultCommand(model);
  }
  
  ElevatorCommand _defaultCommand(ElevatorModel model) => super.nextCommand(model);
  
}


/**
 * This strategy is the same as the Omnibus one but reverse direction as soon as possible
 * and stop when there's nothing to do
 */
class LazyOmnibusStrategy extends OmnibusStrategy {
  
  bool acceptIncomingCall(ElevatorModel model, Call call) {
    if (_stops.isEmpty) {
      return super.acceptIncomingCall(model, call);
    }
    // Accept only stop in the same direction
    else if (call.direction == _stops.first.direction) {
      // Get the stop which is the more far away
      Stop max = _stops.reduce((s1,s2) => s1 < s2 ? s1 : s2);
      // If the elevator is between the max and call then discard it for now
      if (model.between(max, call)) return false;
//      if (model.before(call, model.getDire))
      if (max.before(call, max.direction)) {
        if (call.after(model, max.direction)) return false;
      } 
      else {
        if ((model.before(max, max.direction) && (model.after(call, max.direction)))) return false;
      }
    }
    return false;
  }
  
  ElevatorCommand _defaultCommand(ElevatorModel model) {
    if (_stops.isEmpty) {
      return NOTHING_COMMAND;
    }
    Stop eleStop = new Stop.fromElevator(model);
    return _stops.reduce((s1, s2) => s1 < s2 ? s1 : s2) < eleStop ? UP_COMMAND : DOWN_COMMAND;
  }

}
