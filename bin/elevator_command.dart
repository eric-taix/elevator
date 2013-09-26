part of elevator;

final UP_COMMAND = new UpCommand();
final DOWN_COMMAND = new DownCommand();
final OPEN_COMMAND = new OpenCommand();
final CLOSE_COMMAND = new CloseCommand();
final NOTHING_COMMAND = new NothingCommand();

/**
 * Elevator interface command which is applied to an elevator.
 * 
 * This interface has a named factory constructor to create a command according to a [Direction]. This method returns [UP_COMMAND] or [DOWN_COMMAND].
 * 
 * [ElevatorStrategy] interacts with an elevator by returning these kind of commands
 */
abstract class ElevatorCommand {
  factory ElevatorCommand.fromDirection(Direction direction) => direction == Direction.UP ? UP_COMMAND : DOWN_COMMAND;
  ElevatorCommand();
  String apply(Elevator elevator);
}

class UpCommand extends ElevatorCommand {
  String apply(Elevator elevator) {
    if (elevator._floor < elevator._nbFloor-1) {
      elevator._floor += 1;
      elevator._direction = Direction.UP;
      return 'UP';
    }
    return NOTHING_COMMAND.apply(elevator);
  }
}

class DownCommand extends ElevatorCommand {
  String apply(Elevator elevator) {
    if (elevator._floor > 0) {
      elevator._floor -= 1;
      elevator._direction = Direction.DOWN;
      return 'DOWN';
    }
    return NOTHING_COMMAND.apply(elevator);
  }
}

class OpenCommand extends ElevatorCommand {
  String apply(Elevator elevator) {
    if (!elevator._doorOpen) {
      elevator._doorOpen = true;
      return 'OPEN';
    }
    return NOTHING_COMMAND.apply(elevator);
  }
}

class CloseCommand extends ElevatorCommand {
  String apply(Elevator elevator) {
    if (elevator._doorOpen) {
      elevator._doorOpen = false;
      return 'CLOSE';
    }
    return NOTHING_COMMAND.apply(elevator);
  }
}

class NothingCommand extends ElevatorCommand {
  String apply(Elevator elevator) {
    return 'NOTHING';
  }
}