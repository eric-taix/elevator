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
  
  String toString() => value;
}