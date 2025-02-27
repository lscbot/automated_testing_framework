import 'package:static_translations/static_translations.dart';

class TestStepTranslations {
  TestStepTranslations._();

  static const atf_form_case_sensitive = TranslationEntry(
    key: 'atf_form_case_sensitive',
    value: 'Case Must Match',
  );

  static const atf_form_comment = TranslationEntry(
    key: 'atf_form_comment',
    value: 'Comment',
  );

  static const atf_form_dx = TranslationEntry(
    key: 'atf_form_dx',
    value: 'DX',
  );

  static const atf_form_dy = TranslationEntry(
    key: 'atf_form_dy',
    value: 'DY',
  );

  static const atf_form_equals = TranslationEntry(
    key: 'atf_form_equals',
    value: 'Actual Must Equal Expected',
  );

  static const atf_form_error = TranslationEntry(
    key: 'atf_form_error',
    value: 'Error',
  );

  static const atf_form_field = TranslationEntry(
    key: 'atf_form_field',
    value: 'Field',
  );

  static const atf_form_golden_compatible = TranslationEntry(
    key: 'atf_form_colden_compatible',
    value: 'Golden Compatible',
  );

  static const atf_form_image_id = TranslationEntry(
    key: 'atf_form_image_id',
    value: 'Image ID',
  );

  static const atf_form_scroll_increment = TranslationEntry(
    key: 'atf_form_scroll_increment',
    value: 'Scroll Increment',
  );

  static const atf_form_seconds = TranslationEntry(
    key: 'atf_form_seconds',
    value: 'Seconds',
  );

  static const atf_form_scrollable_id = TranslationEntry(
    key: 'atf_form_scrollable_id',
    value: 'Scrollable ID',
  );

  static const atf_form_type = TranslationEntry(
    key: 'atf_form_type',
    value: 'Type',
  );

  static const atf_form_value = TranslationEntry(
    key: 'atf_form_value',
    value: 'Value',
  );

  static const atf_form_variable_name = TranslationEntry(
    key: 'atf_form_variable_name',
    value: 'Variable Name',
  );

  static const atf_form_widget_id = TranslationEntry(
    key: 'atf_form_widget_id',
    value: 'Testable ID',
  );

  static const atf_help_assert_error = TranslationEntry(
    key: 'atf_help_assert_error',
    value: 'Asserts the error from the widget equals the given value.',
  );

  static const atf_help_assert_semantics = TranslationEntry(
    key: 'atf_help_assert_semantics',
    value: 'Asserts the error from the widget equals the given value.',
  );

  static const atf_help_assert_value = TranslationEntry(
    key: 'atf_help_assert_value',
    value: 'Asserts the value from the widget equals the given value.',
  );

  static const atf_help_comment = TranslationEntry(
    key: 'atf_help_comment',
    value: 'Simply emits the comment to the logs.',
  );

  static const atf_help_dismiss_keyboard = TranslationEntry(
    key: 'atf_help_dismiss_keyboard',
    value:
        'Dismisses the soft keyboard.  If the keyboard is not currently visible, this does nothing.',
  );

  static const atf_help_double_tap = TranslationEntry(
    key: 'atf_help_double_tap',
    value:
        'Double Taps the selected widget.  An error will occur if the widget is not found on the tree before the timeout is exceeded.',
  );

  static const atf_help_drag = TranslationEntry(
    key: 'atf_help_drag',
    value:
        "Drag's the widget in the direction of 'dx' and 'dy'.  One must be set, but both may be.",
  );

  static const atf_help_ensure_exists = TranslationEntry(
    key: 'atf_help_ensure_exists',
    value: 'Ensures the requested widget exists with the set id.',
  );

  static const atf_help_exit_app = TranslationEntry(
    key: 'atf_help_exit_app',
    value:
        'Exits the application.  On mobile and desktop, this will result in the app quitting.  This will do nothing on the Web platform.',
  );

  static const atf_help_go_back = TranslationEntry(
    key: 'atf_help_go_back',
    value: 'Navigates back.  This will fail if there is no back button.',
  );

  static const atf_help_long_press = TranslationEntry(
    key: 'atf_help_long_press',
    value:
        'Long press the selected widget.  An error will occur if the widget is not found on the tree before the timeout is exceeded.',
  );

  static const atf_help_open_menu = TranslationEntry(
    key: 'atf_help_open_menu',
    value: 'Opens the \"hamburger\" menu.',
  );

  static const atf_help_remove_global_variable = TranslationEntry(
    key: 'atf_help_remove_global_variable',
    value: 'Removes a global variable.',
  );

  static const atf_help_remove_variable = TranslationEntry(
    key: 'atf_help_remove_variable',
    value: 'Removes a test variable.',
  );

  static const atf_help_screenshot = TranslationEntry(
    key: 'atf_help_screenshot',
    value:
        'Takes a screenshot and saves it to the test runner.  As a note, screenshots take a up to 5 seconds so this step should be avoided in performance related tests.  Screenshots are not supported on the Web platform.',
  );

  static const atf_help_scroll_until_visible = TranslationEntry(
    key: 'atf_help_scroll_until_visible',
    value: 'Scrolls container widget until the selected widget is visible.',
  );

  static const atf_help_set_global_variable = TranslationEntry(
    key: 'atf_help_set_global_variable',
    value: 'Sets a global variable that persists across test runs.',
  );

  static const atf_help_set_value = TranslationEntry(
    key: 'atf_help_set_value',
    value: 'Sets a value from the widget.',
  );

  static const atf_help_set_variable = TranslationEntry(
    key: 'atf_help_set_variable',
    value:
        'Sets a variable on for use in other test steps within the current test.',
  );

  static const atf_help_sleep = TranslationEntry(
    key: 'atf_help_sleep',
    value: 'Sleeps / pauses the test for the given amount of time.',
  );

  static const atf_help_tap = TranslationEntry(
    key: 'atf_help_tap',
    value:
        'Taps the selected widget.  An error will occur if the widget is not found on the tree before the timeout is exceeded.',
  );

  static const atf_help_wait_for = TranslationEntry(
    key: 'atf_help_wait_for',
    value: 'Waits until the selected widget is available on the widget tree.',
  );

  static const atf_title_assert_error = TranslationEntry(
    key: 'atf_title_assert_errro',
    value: 'Assert Error',
  );

  static const atf_title_assert_semantics = TranslationEntry(
    key: 'atf_title_assert_semantics',
    value: 'Assert Semantics',
  );

  static const atf_title_assert_value = TranslationEntry(
    key: 'atf_title_assert_value',
    value: 'Assert Value',
  );

  static const atf_title_comment = TranslationEntry(
    key: 'atf_title_comment',
    value: 'Comment',
  );

  static const atf_title_dismiss_keyboard = TranslationEntry(
    key: 'atf_title_dismiss_keyboard',
    value: 'Dismiss Keyboard',
  );

  static const atf_title_double_tap = TranslationEntry(
    key: 'atf_title_double_tap',
    value: 'Double Tap',
  );

  static const atf_title_drag = TranslationEntry(
    key: 'atf_title_drag',
    value: 'Drag',
  );

  static const atf_title_ensure_exists = TranslationEntry(
    key: 'atf_title_ensure_exists',
    value: 'Ensure Exists',
  );

  static const atf_title_exit_app = TranslationEntry(
    key: 'atf_title_exit_app',
    value: 'Exit App',
  );

  static const atf_title_go_back = TranslationEntry(
    key: 'atf_title_go_back',
    value: 'Go Back',
  );

  static const atf_title_long_press = TranslationEntry(
    key: 'atf_title_long_press',
    value: 'Long Press',
  );

  static const atf_title_open_menu = TranslationEntry(
    key: 'atf_title_open_menu',
    value: 'Open Menu',
  );

  static const atf_title_remove_global_variable = TranslationEntry(
    key: 'atf_title_remove_global_variable',
    value: 'Remove Global Variable',
  );

  static const atf_title_remove_variable = TranslationEntry(
    key: 'atf_title_remove_variable',
    value: 'Remove Variable',
  );

  static const atf_title_screenshot = TranslationEntry(
    key: 'atf_title_screenshot',
    value: 'Screenshot',
  );

  static const atf_title_scroll_until_visible = TranslationEntry(
    key: 'atf_title_scroll_until_visible',
    value: 'Scroll Until Visible',
  );

  static const atf_title_set_global_variable = TranslationEntry(
    key: 'atf_title_set_global_variable',
    value: 'Set Global Variable',
  );

  static const atf_title_set_value = TranslationEntry(
    key: 'atf_title_set_value',
    value: 'Set Value',
  );

  static const atf_title_set_variable = TranslationEntry(
    key: 'atf_title_set_variable',
    value: 'Set Variable',
  );

  static const atf_title_sleep = TranslationEntry(
    key: 'atf_title_sleep',
    value: 'Sleep',
  );

  static const atf_title_tap = TranslationEntry(
    key: 'atf_title_tap',
    value: 'Tap',
  );

  static const atf_title_wait_for = TranslationEntry(
    key: 'atf_title_wait_for',
    value: 'Wait for Widget (by ID)',
  );
}
