part of elevator;

class CommandStack {
  
  Queue<String> _stack = new Queue();
  int _maxSize;
  int _idx = 1;
  Queue<List<String>> _shots = new Queue();
  
  CommandStack(this._maxSize);
  
  void add(String value) {
    _stack.addLast("${_idx++}: ${value}");
    if (_stack.length > _maxSize) {
      _stack.removeFirst();
    }
  }
  
  void addStackShot(int nbMsg) {
    List<String> shot = new List();
    shot.addAll(_stack.skip(_stack.length > nbMsg ? _stack.length - nbMsg : _stack.length));
    _shots.addLast(shot);
    if (_shots.length > 20) {
      _shots.removeFirst();
    }
  }
  
  String toString() {
    String resets = _shots.fold("", (String result, List<String> values) => result + "\n" + values.fold("\nReset received:\n---------------", (String result, String value) => "${result}\n${value}"));
    String stack = _stack.fold("Command stack:\n--------------", (String result, String value) => "${result}\n${value}");
    return "${resets}\n\n${stack}";
  }
  
}