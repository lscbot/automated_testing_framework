import 'package:automated_testing_framework/automated_testing_framework.dart';

/// Sets a variable on the identified [TestController].
class SetVariableStep extends TestRunnerStep {
  SetVariableStep({
    String type = 'String',
    required this.value,
    required this.variableName,
  })  : assert(type == 'bool' ||
            type == 'double' ||
            type == 'int' ||
            type == 'String'),
        type = type,
        assert(variableName.isNotEmpty == true);

  static const id = 'set_variable';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'set the `{{variableName}}` variable for the test to `{{value}}` using a `{{type}}` type.',
      ]);

  /// The type of value to set.  This must be one of:
  /// * `bool`
  /// * `double`
  /// * `int`
  /// * `String`
  final String type;

  /// The string representation of the value to set.
  final String? value;

  /// The variable name of the variable to set on the controller.
  final String variableName;

  @override
  String get stepId => id;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "type": <String>,
  ///   "value": <String>
  ///   "variableName": <String>,
  /// }
  /// ```
  static SetVariableStep? fromDynamic(dynamic map) {
    SetVariableStep? result;

    if (map != null) {
      result = SetVariableStep(
        type: map['type'] ?? 'String',
        value: map['value']?.toString(),

        /// Accept either "variableName" or "key" for backward compatibility with 1.1.0
        variableName: map['variableName'] ?? map['key'],
      );
    }

    return result;
  }

  /// Sets the variable on the [TestController] for the currently running test.
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    String type = tester.resolveVariable(this.type);
    String? value = tester.resolveVariable(this.value);
    String variableName = tester.resolveVariable(this.variableName);

    assert(type == 'bool' ||
        type == 'double' ||
        type == 'int' ||
        type == 'String');
    assert(variableName.isNotEmpty == true);
    var name = "$id('$variableName', '$type', '$value')";

    log(
      name,
      tester: tester,
    );
    tester.setTestVariable(
      variableName: variableName,
      value: value,
    );
  }

  @override
  String getBehaviorDrivenDescription(TestController tester) =>
      behaviorDrivenDescriptions[0]
          .replaceAll('{{variableName}}', variableName)
          .replaceAll('{{type}}', type)
          .replaceAll('{{value}}', value ?? 'null');

  /// Overidden to ignore the delay
  @override
  Future<void> preStepSleep(Duration duration) async {}

  /// Overidden to ignore the delay
  @override
  Future<void> postStepSleep(Duration duration) async {}

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
        'variableName': variableName,
      };
}
