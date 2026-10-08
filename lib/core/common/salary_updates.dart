import 'dart:async';

/// Successful payroll-affecting writes refresh active read screens.
class SalaryUpdates {
  static final _changes = StreamController<void>.broadcast();
  static Stream<void> get changes => _changes.stream;
  static void notify() => _changes.add(null);
}
