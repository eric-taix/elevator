part of elevator;

/**
 * Interface definition for internal elevator strategy
 */

/**
 * Define the contract for an elevator's strategy. An elevator does not decide what to do: it delegates this choice
 * to an [ElevatorStrategy]
 */
abstract class ElevatorStrategy {
  
  /**
   *  Add an outgoing stop (a person which is in the elevator and want to go somewhere)
   */
  void addOutgoingStop(Stop stop);
  
  /**
   * Does the strategy accept this call
   * 
   * Return [true] if the call is accepted -> The Call must NOT be used anymore
   */
  bool acceptIncomingCall(ElevatorModel model, Call call);
  
  /**
   *  Decides which command to play according to the current model
   */
  ElevatorCommand nextCommand(ElevatorModel model);
  
  /**
   * Reset everything especially internal state
   */
  void reset();

}

/**
 * Common class for instance which have a floor and a direction
 */
abstract class Floorable {
  
  /// Get the floor (current or destination)
  int get floor;
  
  /// Get the direction to take to go to the [otherFloor]
  Direction getDirectionTo(Floorable otherFloor) => floor - otherFloor.floor > 0 ? Direction.UP : Direction.DOWN;
  
  /// Is this floor 'after' the [otherFloor] according to the direction
  bool after(Floorable otherFloor, Direction direction) => (floor - otherFloor.floor) * direction.intValue >= 0 ? true : false;
  
  /// Is this floor 'before' the [otherFloor] according to the direction
  bool before(Floorable otherFloor, Direction direction) => !after(otherFloor, direction);
  
  /// Is the current floor of [this] [Floorable] between floors [other1] and [other2]. Note: [Direction] does not matter in this case
  bool between(Floorable other1, Floorable other2) => (after(other1, Direction.UP) && before(other2, Direction.UP)) || (before(other1, Direction.UP) && after(other2, Direction.UP)) ? true : false;
}


/**
 * An Outgoing stop: someone has pressed the floor button in the elevator
 */
class Stop extends Floorable {
  int _start;
  int _stop;
  Direction _direction;
  
  Stop(this._start, this._stop, this._direction);
  Stop.fromElevator(ElevatorModel model) : this(model.floor, model.floor, model.direction);
  Stop.fromCall(Call call) : this(call.floor, call.floor, call.direction);
  
  int get start => _start;
  int get floor => _stop;
  Direction get direction => _direction;
  
  get hashCode => _stop;
  
  bool operator == (Stop other) => _stop == other._stop && _direction == other._direction;
  
  /**
   * Greater than operator. CAREFUL greater means 'after' according the current direction
   * 
   * For example s1.stop = 4; s2.stop = 1; s1 > s4 is true direction is UP but false otherwise
   */
  bool operator > (Stop other) => (_direction.intValue * (_stop - other._stop)) > 0 ? true : false;
  
  /**
   * Greater or equal than operator. CAREFUL greater means 'after' according the current direction
   * 
   * For example s1.stop = 4; s2.stop = 1; s1 >= s4 is true direction is UP but false otherwise
   */
  bool operator >= (Stop other) => (_direction.intValue * (_stop - other._stop)) >= 0 ? true : false;
  
  /**
   * Lower than operator. CAREFUL greater means 'before' according the current direction
   * 
   * For example s1.stop = 4; s2.stop = 1; s1 < s4 is true direction is DOWN but false otherwise
   */
  bool operator < (Stop other) => (_direction.intValue * (_stop - other._stop)) < 0 ? true : false;
  
  /**
   * Lower or equal than operator. CAREFUL greater means 'before' according the current direction
   * 
   * For example s1.stop = 4; s2.stop = 1; s1 <= s4 is true direction is DOWN but false otherwise
   */
  bool operator <= (Stop other) => (_direction.intValue * (_stop - other._stop)) <= 0 ? true : false;
  
  String toString() => '(${floor}:${_direction.value})';
}


/**
 *  A incoming call: someone has called for the elevator
 */
class Call extends Floorable {
  int _atFloor;
  Direction _direction;
  
  Call(this._atFloor, this._direction);
  
  int get floor => _atFloor;
  Direction get direction => _direction;
}