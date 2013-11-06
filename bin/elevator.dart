part of elevator;


/**
 * A read-only elevator model
 */
class ElevatorModel extends Floorable {
  // Internal floor of the elevator. This attribut can't be changed from outside
  int _floor = 0;
  // The maximum number of floor
  int _nbFloor;
  // Internal state of current direction of the elevator
  Direction _direction = Direction.UP;
  // Internal state which reprensents if the door is open
  bool _doorOpen = false;
  
  ElevatorModel(this._nbFloor);
  
  int get floor => _floor;
  Direction get direction => _direction;
  bool get doorOpen => _doorOpen;
  
  // Is the elevator at floor 0 ?
  bool get isGround => _floor == 0;
  // Is the elevator at the maximum floor ?
  bool get isHeaven => _floor == (_nbFloor-1);
  
}

/**
 * An elevator
 */
class Elevator extends ElevatorModel {

  // The strategy to use when deciding what to do
  ElevatorStrategy _strategy;
  
  Elevator(int maxFloor, this._strategy) : super(maxFloor);
  
  /**
   * Someone call for the elevator.
   * [call] The requested call
   */
  bool acceptCall(Call call) {
    return _strategy.acceptIncomingCall(this, call);
  }
  
  /**
   *  Add a new stop. A new stop is added according to the current floor and the direction of the elevator
   *  [newFloor] The new floor to stop
   */
  void goTo(int newFloor) {
    _strategy.addOutgoingStop(new Stop(_floor, newFloor, (newFloor > _floor ? Direction.UP : Direction.DOWN)));
  }
  
  /**
   *  Return the next command
   */
  ElevatorCommand nextCommand() => _strategy.nextCommand(this);

  /**
   * Reset every internal states
   */
  void reset() {
    _floor =0;
    _direction = Direction.UP;
    _doorOpen = false;
    _strategy.reset();
  }
  
  String toString() => 'Floor ${_floor}, Direction ${_direction}, Stops:${_strategy}';
}