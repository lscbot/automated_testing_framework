import 'dart:io';

import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:static_translations/static_translations.dart';

/// Tab that shows the test steps in a drag-and-drop reorderable format.
class TestStepListMinifiedTab extends StatefulWidget {
  TestStepListMinifiedTab({
    this.doublePop = true,
    Key? key,
  }) : super(key: key);

  final bool? doublePop;

  @override
  _TestStepListMinifiedTabState createState() =>
      _TestStepListMinifiedTabState();
}

class _TestStepListMinifiedTabState extends State<TestStepListMinifiedTab> {
  late TestController _testController;

  @override
  void initState() {
    super.initState();

    _testController = TestController.of(context)!;
  }

  void _onDeleteStep({
    required TestStep step,
  }) {
    var steps = List<TestStep>.from(
      _testController.currentTest.steps,
    );

    steps.remove(step);
    _testController.currentTest = _testController.currentTest.copyWith(
      steps: steps,
    );
    if (mounted == true) {
      setState(() {});
    }
  }

  Future<void> _onEditStep({
    required TestStep step,
    required ThemeData theme,
    required Translator translator,
  }) async {
    var steps = List<TestStep>.from(
      _testController.currentTest.steps,
    );

    var values = step.values ?? <String, dynamic>{};
    var idx = steps.indexOf(step);
    var availableStep = TestStepRegistry.of(context).getAvailableTestStep(
      step.id,
    );

    if (availableStep != null) {
      var newValues = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => TestableFormPage(
            form: availableStep.form,
            values: values,
          ),
        ),
      );

      if (newValues != null) {
        steps.removeAt(idx);
        steps.insert(
          idx,
          step.copyWith(
            values: newValues,
          ),
        );
        _testController.currentTest = _testController.currentTest.copyWith(
          steps: steps,
        );

        if (mounted == true) {
          setState(() {});
        }
      }
    } else {
      await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => Theme(
          data: theme,
          child: AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  translator.translate(
                    TestTranslations.atf_button_cancel,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    TextStyle(color: theme.errorColor),
                  ),
                ),
                child: Text(
                  translator.translate(
                    TestTranslations.atf_button_clear,
                  ),
                ),
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: theme.textTheme.bodyText2!.color,
                  size: 54.0,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  translator.translate(
                    TestTranslations.atf_clear_confirmation,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> _run({
    required TestStep step,
    required TestController tester,
  }) async {
    if (widget.doublePop == true) {
      Navigator.of(context).pop();
    }

    Navigator.of(context).pop();

    try {
      await tester.execute(
        reset: false,
        steps: [step],
        submitReport: false,
        version: 0,
      );
    } catch (e) {
      tester.sleep = null;
      tester.step = null;
    }
  }

  Widget _buildMinifiedStep(
    BuildContext context, {
    required int index,
    required TestStep step,
  }) {
    var mq = MediaQuery.of(context);
    var narrow = mq.size.width - mq.padding.horizontal < 500.0;
    var tester = TestController.of(context);
    var theme = TestRunner.of(context)?.theme ?? Theme.of(context);
    var translator = Translator.of(context);

    return ListTile(
      key: ValueKey(step.key),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 40.0 + 16.0 + 48.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: tester!.currentTest.pinnedStepIndex == index
                      ? Center(
                          child: Tooltip(
                            message: translator.translate(
                              TestTranslations.atf_step_currently_pinned,
                            ),
                            child: Icon(
                              Icons.label,
                              color: Colors.green,
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            tester.currentTest.pinnedStepIndex = index;

                            if (mounted == true) {
                              setState(() {});
                            }
                          },
                          tooltip: translator.translate(
                            TestTranslations.atf_pin_step,
                          ),
                          icon: Icon(Icons.label_outline),
                        ),
                ),
                SizedBox(width: 16.0),
                Text('${index + 1}'),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  step.id,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Courier New',
                    fontFamilyFallback: ['monospace', 'Courier'],
                  ),
                ),
                if ((step.values ?? {})['testableId']?.isNotEmpty == true)
                  Padding(
                    padding: EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Text(
                      step.values!['testableId'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.caption,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      trailing: Padding(
        padding: EdgeInsets.only(
            right: (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                ? 0.0
                : 32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (narrow != true) ...[
              Tooltip(
                message:
                    translator.translate(TestTranslations.atf_button_delete),
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: theme.errorColor,
                  ),
                  onPressed: () => _onDeleteStep(step: step),
                ),
              ),
              SizedBox(width: 16.0),
              Tooltip(
                message: translator.translate(TestTranslations.atf_button_edit),
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: () => _onEditStep(
                    step: step,
                    theme: theme,
                    translator: translator,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Tooltip(
                message: translator.translate(
                  TestTranslations.atf_button_run,
                ),
                child: IconButton(
                  color: theme.iconTheme.color,
                  icon: Icon(Icons.play_arrow),
                  onPressed: () => _run(step: step, tester: tester),
                ),
              ),
            ],
            if (narrow) ...[
              SizedBox(width: 16.0),
              PopupMenuButton(
                itemBuilder: (context) => <PopupMenuItem<VoidCallback>>[
                  PopupMenuItem(
                    value: () => _run(tester: tester, step: step),
                    child: Text(
                      translator.translate(TestTranslations.atf_button_run),
                    ),
                  ),
                  PopupMenuItem(
                    value: () => _onEditStep(
                      step: step,
                      theme: theme,
                      translator: translator,
                    ),
                    child: Text(
                      translator.translate(TestTranslations.atf_button_edit),
                    ),
                  ),
                  PopupMenuItem(
                    value: () => _onDeleteStep(step: step),
                    child: Text(
                      translator.translate(TestTranslations.atf_button_delete),
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
                onSelected: (Function? value) {
                  if (value != null) {
                    value();
                  }
                },
                child: Icon(Icons.more_horiz),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      buildDefaultDragHandles: true,
      onReorder: (int oldIndex, int newIndex) {
        var steps = List<TestStep>.from(
          _testController.currentTest.steps,
        );
        var step = steps[oldIndex];

        steps.removeAt(oldIndex);
        if (oldIndex > newIndex) {
          steps.insert(newIndex, step);
        } else {
          steps.insert(newIndex - 1, step);
        }

        _testController.currentTest =
            _testController.currentTest.copyWith(steps: steps);
        if (mounted == true) {
          setState(() {});
        }
      },
      children: <Widget>[
        for (var i = 0; i < _testController.currentTest.steps.length; i++)
          _buildMinifiedStep(
            context,
            index: i,
            step: _testController.currentTest.steps[i],
          ),
      ],
    );
  }
}
