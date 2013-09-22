part of elevator;

/// An elevator
class Elevator {
  // Internal floor of the elevator. This attribut can't be changed from outside
  int _floor = 0;
  // Internal state which reprensents if the door is open
  bool _doorOpen = false;
  // The current direction of the elevator
  Direction _direction = Direction.UP;
  // List of stops (up and down directions)
  Map<Direction, Set<int>> _stops = new Map();
  
  int get floor => _floor;
  
  /// Returns the current stops in the current direction
  Set<int> get currentStops => _stops[_direction];
  /// Returns the current stops in the current direction
  Set<int> get oppositeStops => _stops[_direction.not()];
  
  Elevator() {
    _stops[Direction.UP]= new Set(); 
    _stops[Direction.DOWN]= new Set(); 
    reset();
  }
  
  /**
   * Someone call for the elevator. Add the requested stop according to the direction only
   * [newFloor] The requested floor
   * [direction] The requested direction
   */
  void call(int newFloor, Direction direction) {
    go(newFloor);
  }
  
  /**
   *  Add a new stop. A new stop is added according to the current floor and the direction of the elevator
   *  [newFloor] The new floor to stop
   */
  void go(int newFloor) {
    if (newFloor < _floor) {
      _stops[Direction.DOWN].add(newFloor);
    } else if (newFloor > _floor) {
      _stops[Direction.UP].add(newFloor);
    } else {
      _stops[_direction].add(_floor);
    }
  }
  
  /**
   * Returns true if the current floor is the expected floor
   */
  bool _expectedFloor(int floor) => floor == _floor;
  
  String _openDoor() {
    _doorOpen = true;
    return 'OPEN';
  }
  
  String _closeDoor() {
    _doorOpen = false;
    return 'CLOSE';
  }
  
  /**
   *  Return the next command
   */
  String nextCommand() {
    // First do we have some stop at the current floor ?
    List<int> stops = currentStops.where(_expectedFloor).toList();
    if (!stops.isEmpty) {
      currentStops.removeWhere(_expectedFloor);
      if (!_doorOpen) {
        return _openDoor();
      }
    }
    // If no stop here, then verify if the door is closed
    if (_doorOpen) {
      return _closeDoor();
    }
    // If there's more stop in the current direction the continue to move
    if (!currentStops.isEmpty) {
      _floor += _direction == Direction.UP ? 1 : -1;
      return _direction.value;
    }
    // Ok no more stop in this direction, try in the opposite direction
    Direction o = _direction.not();
    if (!_stops[_direction.not()].isEmpty) {
      _direction = _direction.not();
      return nextCommand();
    }
    return 'NOTHING';
  }
  
  /**
   * Reset every internal states
   */
  void reset() {
    _floor =0;
    _direction = Direction.UP;
    _doorOpen = false;
    _stops.forEach((dir, Set set) => set.clear());
  }
  
  String toString() => 'Floor ${_floor}, Direction ${_direction}, CurrentStops ${currentStops}, OppositeStop ${oppositeStops}';
}