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
 * An Outgoing stop: someone has pressed the floor button in the elevator
 */
class Stop {
  int _start;
  int _stop;
  Direction _direction;
  
  Stop(this._start, this._stop, this._direction);
  Stop.fromCall(Call call) : this(call.atFloor, call.atFloor, call.direction);
  
  int get start => _start;
  int get stop => _stop;
  Direction get direction => _direction;
  
  get hashCode => _stop;
  bool operator == (other) => _stop == other._stop && _direction == other._direction;
  String toString() => '(${stop}:${_direction.value})';
}


/**
 *  A incoming call: someone has called for the elevator
 */
class Call {
  int _atFloor;
  Direction _direction;
  
  Call(this._atFloor, this._direction);
  
  int get atFloor => _atFloor;
  Direction get direction => _direction;
}