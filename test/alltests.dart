import 'package:unittest/unittest.dart';
import '../bin/building.dart';
import 'package:unittest/vm_config.dart';

main() {
  useVMConfiguration();
  
  Elevator ele = new Elevator(5, new LazyOmnibusStrategy());
  
  group('Command /', () {
    test('Reset', () {
      ele.reset();
      expect(ele.floor, equals(0));
      expect(ele.direction, equals(Direction.UP));
      expect(ele.doorOpen, isFalse);
    });
    test('Open door', () {
      ele.reset();
      OPEN_COMMAND.apply(ele);
      expect(ele.doorOpen, isTrue);
    });
    test('Close door', () {
      ele.reset();
      OPEN_COMMAND.apply(ele);
      expect(ele.doorOpen, isTrue);
      CLOSE_COMMAND.apply(ele);
      expect(ele.doorOpen, isFalse);
    });
    test('Go up', () {
      ele.reset();
      UP_COMMAND.apply(ele);
      expect(ele.floor, equals(1));
    });
    test('Go down', () {
      ele.reset();
      UP_COMMAND.apply(ele);
      expect(ele.floor, equals(1));
      DOWN_COMMAND.apply(ele);
      expect(ele.floor, equals(0));
    });
    test('Stop at heaven/', () {
      ele.reset();
      UP_COMMAND.apply(ele);
      UP_COMMAND.apply(ele);
      UP_COMMAND.apply(ele);
      UP_COMMAND.apply(ele);
      expect(ele.floor, equals(4));
      UP_COMMAND.apply(ele);
      expect(ele.floor, equals(4));
    });
    test('Stop at ground/', () {
      ele.reset();
      UP_COMMAND.apply(ele);
      UP_COMMAND.apply(ele);
      expect(ele.floor, equals(2));
      DOWN_COMMAND.apply(ele);
      DOWN_COMMAND.apply(ele);
      expect(ele.floor, equals(0));
      DOWN_COMMAND.apply(ele);
      expect(ele.floor, equals(0));
    });
  });
  group('Call /', () {
    test('Accept to up', () {
      ele.reset();
      expect(ele.acceptCall(new Call(2, Direction.UP)), isTrue);
      expect(ele.acceptCall(new Call(1, Direction.UP)), isTrue);
      ele.reset();
      expect(ele.acceptCall(new Call(1, Direction.UP)), isTrue);
      expect(ele.acceptCall(new Call(2, Direction.UP)), isTrue);
      ele.reset();
      UP_COMMAND.apply(ele);
      expect(ele.acceptCall(new Call(0, Direction.UP)), isTrue);
      expect(ele.acceptCall(new Call(2, Direction.UP)), isTrue);
      ele.reset();
      UP_COMMAND.apply(ele);
      expect(ele.acceptCall(new Call(2, Direction.UP)), isTrue);
      expect(ele.acceptCall(new Call(0, Direction.UP)), isFalse);
      ele.reset();
      UP_COMMAND.apply(ele);
      UP_COMMAND.apply(ele);
      expect(ele.acceptCall(new Call(1, Direction.UP)), isTrue);
      expect(ele.acceptCall(new Call(0, Direction.UP)), isTrue);
      ele.reset();
      UP_COMMAND.apply(ele);
      UP_COMMAND.apply(ele);
      expect(ele.acceptCall(new Call(0, Direction.UP)), isTrue);
      expect(ele.acceptCall(new Call(1, Direction.UP)), isTrue);
    });
    test('Accept to down', () {
      ele.reset();
      expect(ele.acceptCall(new Call(2, Direction.DOWN)), isTrue);
      expect(ele.acceptCall(new Call(1, Direction.DOWN)), isTrue);
      ele.reset();
      expect(ele.acceptCall(new Call(1, Direction.DOWN)), isTrue);
      expect(ele.acceptCall(new Call(2, Direction.DOWN)), isTrue);
      ele.reset();
      UP_COMMAND.apply(ele);
      expect(ele.acceptCall(new Call(0, Direction.DOWN)), isTrue);
      expect(ele.acceptCall(new Call(2, Direction.DOWN)), isFalse);
      ele.reset();
      UP_COMMAND.apply(ele);
      expect(ele.acceptCall(new Call(2, Direction.DOWN)), isTrue);
      expect(ele.acceptCall(new Call(0, Direction.DOWN)), isTrue);
      ele.reset();
      UP_COMMAND.apply(ele);
      UP_COMMAND.apply(ele);
      expect(ele.acceptCall(new Call(0, Direction.DOWN)), isTrue);
      expect(ele.acceptCall(new Call(1, Direction.DOWN)), isTrue);
      ele.reset();
      UP_COMMAND.apply(ele);
      UP_COMMAND.apply(ele);
      expect(ele.acceptCall(new Call(1, Direction.DOWN)), isTrue);
      expect(ele.acceptCall(new Call(0, Direction.DOWN)), isTrue);
    });

  });

  
  
    

}