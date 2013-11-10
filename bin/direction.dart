part of elevator;

/**
 * An enumeration for direction (UP or DOWN)
 */
class Direction {
  static const UP = const Direction._('UP');
  static const DOWN = const Direction._('DOWN');
  static const NONE = const Direction._('NONE');

  final String value;

  const Direction._(this.value);
  
  /**
   * Return the opposite direction
   */
  Direction not() {
    if (this != Direction.NONE) return this == UP ? DOWN : UP;
    return this;
  }
  
  /**
   * Get the direction as int. Can be used to multiply a diff between two stops to know which one is after the other
   */
  int get intValue {
    if (this == Direction.NONE) return 0;
    return this == Direction.UP ? 1 : -1;
  }
  
  String toString() => value;
}