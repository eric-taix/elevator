part of elevator;

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
  
  /**
   * Get the direction as int. Can be used to multiply a diff between two stops to know which one is after the other
   */
  int get intValue => this == Direction.UP ? 1 : -1;
  
  String toString() => value;
}