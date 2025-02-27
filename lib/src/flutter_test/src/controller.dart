// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'all_elements.dart';
import 'finders.dart';
import 'test_pointer.dart';

/// The default drag touch slop used to break up a large drag into multiple
/// smaller moves.
///
/// This value must be greater than [kTouchSlop].
const double kDragSlopDefault = 20.0;

/// Class that programmatically interacts with widgets.
///
/// For a variant of this class suited specifically for unit tests, see
/// [WidgetTester]. For one suitable for live tests on a device, consider
/// [LiveWidgetController].
///
/// Concrete subclasses must implement the [pump] method.
abstract class WidgetController {
  /// Creates a widget controller that uses the given binding.
  WidgetController(this.binding);

  /// A reference to the current instance of the binding.
  final WidgetsBinding binding;

  // FINDER API

  // TODO(ianh): verify that the return values are of type T and throw
  // a good message otherwise, in all the generic methods below

  /// Checks if `finder` exists in the tree.
  bool any(Finder finder) {
    return finder.evaluate().isNotEmpty;
  }

  /// All widgets currently in the widget tree (lazy pre-order traversal).
  ///
  /// Can contain duplicates, since widgets can be used in multiple
  /// places in the widget tree.
  Iterable<Widget> get allWidgets {
    return allElements.map<Widget>((Element? element) => element!.widget);
  }

  /// The matching widget in the widget tree.
  ///
  /// Throws a [StateError] if `finder` is empty or matches more than
  /// one widget.
  ///
  /// * Use [firstWidget] if you expect to match several widgets but only want the first.
  /// * Use [widgetList] if you expect to match several widgets and want all of them.
  T widget<T extends Widget>(Finder finder) {
    return finder.evaluate().single.widget as T;
  }

  /// The first matching widget according to a depth-first pre-order
  /// traversal of the widget tree.
  ///
  /// Throws a [StateError] if `finder` is empty.
  ///
  /// * Use [widget] if you only expect to match one widget.
  T firstWidget<T extends Widget>(Finder finder) {
    return finder.evaluate().first.widget as T;
  }

  /// The matching widgets in the widget tree.
  ///
  /// * Use [widget] if you only expect to match one widget.
  /// * Use [firstWidget] if you expect to match several but only want the first.
  Iterable<T> widgetList<T extends Widget>(Finder finder) {
    return finder.evaluate().map<T>((Element? element) {
      final result = element!.widget as T;
      return result;
    });
  }

  /// All elements currently in the widget tree (lazy pre-order traversal).
  ///
  /// The returned iterable is lazy. It does not walk the entire widget tree
  /// immediately, but rather a chunk at a time as the iteration progresses
  /// using [Iterator.moveNext].
  Iterable<Element> get allElements {
    return collectAllElementsFrom(binding.renderViewElement!,
        skipOffstage: false);
  }

  /// The matching element in the widget tree.
  ///
  /// Throws a [StateError] if `finder` is empty or matches more than
  /// one element.
  ///
  /// * Use [firstElement] if you expect to match several elements but only want the first.
  /// * Use [elementList] if you expect to match several elements and want all of them.
  T element<T extends Element>(Finder finder) {
    return finder.evaluate().single as T;
  }

  /// The first matching element according to a depth-first pre-order
  /// traversal of the widget tree.
  ///
  /// Throws a [StateError] if `finder` is empty.
  ///
  /// * Use [element] if you only expect to match one element.
  T firstElement<T extends Element>(Finder finder) {
    return finder.evaluate().first as T;
  }

  /// The matching elements in the widget tree.
  ///
  /// * Use [element] if you only expect to match one element.
  /// * Use [firstElement] if you expect to match several but only want the first.
  Iterable<T> elementList<T extends Element>(Finder finder) {
    return finder.evaluate().cast<T>();
  }

  /// All states currently in the widget tree (lazy pre-order traversal).
  ///
  /// The returned iterable is lazy. It does not walk the entire widget tree
  /// immediately, but rather a chunk at a time as the iteration progresses
  /// using [Iterator.moveNext].
  Iterable<State> get allStates {
    return allElements
        .whereType<StatefulElement>()
        .map<State>((StatefulElement element) => element.state);
  }

  /// The matching state in the widget tree.
  ///
  /// Throws a [StateError] if `finder` is empty, matches more than
  /// one state, or matches a widget that has no state.
  ///
  /// * Use [firstState] if you expect to match several states but only want the first.
  /// * Use [stateList] if you expect to match several states and want all of them.
  T state<T extends State>(Finder finder) {
    return _stateOf<T>(finder.evaluate().single, finder);
  }

  /// The first matching state according to a depth-first pre-order
  /// traversal of the widget tree.
  ///
  /// Throws a [StateError] if `finder` is empty or if the first
  /// matching widget has no state.
  ///
  /// * Use [state] if you only expect to match one state.
  T firstState<T extends State>(Finder finder) {
    return _stateOf<T>(finder.evaluate().first, finder);
  }

  /// The matching states in the widget tree.
  ///
  /// Throws a [StateError] if any of the elements in `finder` match a widget
  /// that has no state.
  ///
  /// * Use [state] if you only expect to match one state.
  /// * Use [firstState] if you expect to match several but only want the first.
  Iterable<T> stateList<T extends State>(Finder finder) {
    return finder
        .evaluate()
        .map<T>((Element? element) => _stateOf<T>(element, finder));
  }

  T _stateOf<T extends State>(Element? element, Finder finder) {
    if (element is StatefulElement) return element.state as T;
    throw StateError(
        'Widget of type ${element!.widget.runtimeType}, with ${finder.description}, is not a StatefulWidget.');
  }

  /// Render objects of all the widgets currently in the widget tree
  /// (lazy pre-order traversal).
  ///
  /// This will almost certainly include many duplicates since the
  /// render object of a [StatelessWidget] or [StatefulWidget] is the
  /// render object of its child; only [RenderObjectWidget]s have
  /// their own render object.
  Iterable<RenderObject?> get allRenderObjects {
    return allElements
        .map<RenderObject?>((Element? element) => element!.renderObject);
  }

  /// The render object of the matching widget in the widget tree.
  ///
  /// Throws a [StateError] if `finder` is empty or matches more than
  /// one widget (even if they all have the same render object).
  ///
  /// * Use [firstRenderObject] if you expect to match several render objects but only want the first.
  /// * Use [renderObjectList] if you expect to match several render objects and want all of them.
  T? renderObject<T extends RenderObject?>(Finder finder) {
    return finder.evaluate().single.renderObject as T?;
  }

  /// The render object of the first matching widget according to a
  /// depth-first pre-order traversal of the widget tree.
  ///
  /// Throws a [StateError] if `finder` is empty.
  ///
  /// * Use [renderObject] if you only expect to match one render object.
  T? firstRenderObject<T extends RenderObject?>(Finder finder) {
    return finder.evaluate().first.renderObject as T?;
  }

  /// The render objects of the matching widgets in the widget tree.
  ///
  /// * Use [renderObject] if you only expect to match one render object.
  /// * Use [firstRenderObject] if you expect to match several but only want the first.
  Iterable<T?> renderObjectList<T extends RenderObject?>(Finder finder) {
    return finder.evaluate().map<T?>((Element? element) {
      final result = element!.renderObject as T?;
      return result;
    });
  }

  /// Returns a list of all the [Layer] objects in the rendering.
  List<Layer> get layers => _walkLayers(binding.renderView.debugLayer).toList();
  Iterable<Layer> _walkLayers(Layer? layer) sync* {
    yield layer!;
    if (layer is ContainerLayer) {
      final root = layer;
      var child = root.firstChild;
      while (child != null) {
        yield* _walkLayers(child);
        child = child.nextSibling;
      }
    }
  }

  // INTERACTION

  /// Dispatch a pointer down / pointer up sequence at the center of
  /// the given widget, assuming it is exposed.
  ///
  /// If the center of the widget is not exposed, this might send events to
  /// another object.
  Future<void> tap(Finder finder,
      {int? pointer, int buttons = kPrimaryButton}) {
    return tapAt(getCenter(finder), pointer: pointer, buttons: buttons);
  }

  /// Dispatch a pointer down / pointer up sequence at the given location.
  Future<void> tapAt(Offset location,
      {int? pointer, int buttons = kPrimaryButton}) async {
    final gesture =
        await startGesture(location, pointer: pointer, buttons: buttons);
    await gesture.up();
  }

  /// Dispatch a pointer down at the center of the given widget, assuming it is
  /// exposed.
  ///
  /// If the center of the widget is not exposed, this might send events to
  /// another object.
  Future<TestGesture> press(Finder finder,
      {int? pointer, int buttons = kPrimaryButton}) async {
    return startGesture(getCenter(finder), pointer: pointer, buttons: buttons);
  }

  /// Dispatch a pointer down / pointer up sequence (with a delay of
  /// [kLongPressTimeout] + [kPressTimeout] between the two events) at the
  /// center of the given widget, assuming it is exposed.
  ///
  /// If the center of the widget is not exposed, this might send events to
  /// another object.
  Future<void> longPress(Finder finder,
      {int? pointer, int buttons = kPrimaryButton}) {
    return longPressAt(getCenter(finder), pointer: pointer, buttons: buttons);
  }

  /// Dispatch a pointer down / pointer up sequence at the given location with
  /// a delay of [kLongPressTimeout] + [kPressTimeout] between the two events.
  Future<void> longPressAt(Offset location,
      {int? pointer, int buttons = kPrimaryButton}) async {
    final gesture =
        await startGesture(location, pointer: pointer, buttons: buttons);
    await pump(kLongPressTimeout + kPressTimeout);
    await gesture.up();
  }

  /// Attempts a fling gesture starting from the center of the given
  /// widget, moving the given distance, reaching the given speed.
  ///
  /// If the middle of the widget is not exposed, this might send
  /// events to another object.
  ///
  /// This can pump frames. See [flingFrom] for a discussion of how the
  /// `offset`, `velocity` and `frameInterval` arguments affect this.
  ///
  /// The `speed` is in pixels per second in the direction given by `offset`.
  ///
  /// A fling is essentially a drag that ends at a particular speed. If you
  /// just want to drag and end without a fling, use [drag].
  ///
  /// The `initialOffset` argument, if non-zero, causes the pointer to first
  /// apply that offset, then pump a delay of `initialOffsetDelay`. This can be
  /// used to simulate a drag followed by a fling, including dragging in the
  /// opposite direction of the fling (e.g. dragging 200 pixels to the right,
  /// then fling to the left over 200 pixels, ending at the exact point that the
  /// drag started).
  Future<void> fling(
    Finder finder,
    Offset offset,
    double speed, {
    int? pointer,
    int buttons = kPrimaryButton,
    Duration frameInterval = const Duration(milliseconds: 16),
    Offset initialOffset = Offset.zero,
    Duration initialOffsetDelay = const Duration(seconds: 1),
  }) {
    return flingFrom(
      getCenter(finder),
      offset,
      speed,
      pointer: pointer,
      buttons: buttons,
      frameInterval: frameInterval,
      initialOffset: initialOffset,
      initialOffsetDelay: initialOffsetDelay,
    );
  }

  /// Attempts a fling gesture starting from the given location, moving the
  /// given distance, reaching the given speed.
  ///
  /// Exactly 50 pointer events are synthesized.
  ///
  /// The offset and speed control the interval between each pointer event. For
  /// example, if the offset is 200 pixels down, and the speed is 800 pixels per
  /// second, the pointer events will be sent for each increment of 4 pixels
  /// (200/50), over 250ms (200/800), meaning events will be sent every 1.25ms
  /// (250/200).
  ///
  /// To make tests more realistic, frames may be pumped during this time (using
  /// calls to [pump]). If the total duration is longer than `frameInterval`,
  /// then one frame is pumped each time that amount of time elapses while
  /// sending events, or each time an event is synthesized, whichever is rarer.
  ///
  /// A fling is essentially a drag that ends at a particular speed. If you
  /// just want to drag and end without a fling, use [dragFrom].
  ///
  /// The `initialOffset` argument, if non-zero, causes the pointer to first
  /// apply that offset, then pump a delay of `initialOffsetDelay`. This can be
  /// used to simulate a drag followed by a fling, including dragging in the
  /// opposite direction of the fling (e.g. dragging 200 pixels to the right,
  /// then fling to the left over 200 pixels, ending at the exact point that the
  /// drag started).
  Future<void> flingFrom(
    Offset startLocation,
    Offset offset,
    double speed, {
    int? pointer,
    int buttons = kPrimaryButton,
    Duration frameInterval = const Duration(milliseconds: 16),
    Offset initialOffset = Offset.zero,
    Duration initialOffsetDelay = const Duration(seconds: 1),
  }) async {
    assert(offset.distance > 0.0);
    assert(speed > 0.0); // speed is pixels/second
    final testPointer = TestPointer(
        pointer ?? _getNextPointer(), PointerDeviceKind.touch, null, buttons);
    final result = hitTestOnBinding(startLocation);
    const kMoveCount =
        50; // Needs to be >= kHistorySize, see _LeastSquaresVelocityTrackerStrategy
    final timeStampDelta = 1000.0 * offset.distance / (kMoveCount * speed);
    var timeStamp = 0.0;
    var lastTimeStamp = timeStamp;
    await sendEventToBinding(
        testPointer.down(startLocation,
            timeStamp: Duration(milliseconds: timeStamp.round())),
        result);
    if (initialOffset.distance > 0.0) {
      await sendEventToBinding(
          testPointer.move(startLocation + initialOffset,
              timeStamp: Duration(milliseconds: timeStamp.round())),
          result);
      timeStamp += initialOffsetDelay.inMilliseconds;
      await pump(initialOffsetDelay);
    }
    for (var i = 0; i <= kMoveCount; i += 1) {
      final location = startLocation +
          initialOffset +
          Offset.lerp(Offset.zero, offset, i / kMoveCount)!;
      await sendEventToBinding(
          testPointer.move(location,
              timeStamp: Duration(milliseconds: timeStamp.round())),
          result);
      timeStamp += timeStampDelta;
      if (timeStamp - lastTimeStamp > frameInterval.inMilliseconds) {
        await pump(
            Duration(milliseconds: (timeStamp - lastTimeStamp).truncate()));
        lastTimeStamp = timeStamp;
      }
    }
    await sendEventToBinding(
        testPointer.up(timeStamp: Duration(milliseconds: timeStamp.round())),
        result);
  }

  /// Called to indicate that time should advance.
  ///
  /// This is invoked by [flingFrom], for instance, so that the sequence of
  /// pointer events occurs over time.
  ///
  /// The [WidgetTester] subclass implements this by deferring to the [binding].
  ///
  /// See also [SchedulerBinding.endOfFrame], which returns a future that could
  /// be appropriate to return in the implementation of this method.
  Future<void> pump(Duration? duration);

  /// Attempts to drag the given widget by the given offset, by
  /// starting a drag in the middle of the widget.
  ///
  /// If the middle of the widget is not exposed, this might send
  /// events to another object.
  ///
  /// If you want the drag to end with a speed so that the gesture recognition
  /// system identifies the gesture as a fling, consider using [fling] instead.
  ///
  /// {@template flutter.flutter_test.drag}
  /// By default, if the x or y component of offset is greater than [kTouchSlop], the
  /// gesture is broken up into two separate moves calls. Changing 'touchSlopX' or
  /// `touchSlopY` will change the minimum amount of movement in the respective axis
  /// before the drag will be broken into multiple calls. To always send the
  /// drag with just a single call to [TestGesture.moveBy], `touchSlopX` and `touchSlopY`
  /// should be set to 0.
  ///
  /// Breaking the drag into multiple moves is necessary for accurate execution
  /// of drag update calls with a [DragStartBehavior] variable set to
  /// [DragStartBehavior.start]. Without such a change, the dragUpdate callback
  /// from a drag recognizer will never be invoked.
  ///
  /// To force this function to a send a single move event, the 'touchSlopX' and
  /// 'touchSlopY' variables should be set to 0. However, generally, these values
  /// should be left to their default values.
  /// {@endtemplate}
  Future<void> drag(
    Finder finder,
    Offset offset, {
    int? pointer,
    int buttons = kPrimaryButton,
    double touchSlopX = kDragSlopDefault,
    double touchSlopY = kDragSlopDefault,
  }) {
    assert(kDragSlopDefault > kTouchSlop);
    return dragFrom(
      getCenter(finder),
      offset,
      pointer: pointer,
      buttons: buttons,
      touchSlopX: touchSlopX,
      touchSlopY: touchSlopY,
    );
  }

  /// Attempts a drag gesture consisting of a pointer down, a move by
  /// the given offset, and a pointer up.
  ///
  /// If you want the drag to end with a speed so that the gesture recognition
  /// system identifies the gesture as a fling, consider using [flingFrom]
  /// instead.
  ///
  /// {@macro flutter.flutter_test.drag}
  Future<void> dragFrom(
    Offset startLocation,
    Offset offset, {
    int? pointer,
    int buttons = kPrimaryButton,
    double touchSlopX = kDragSlopDefault,
    double touchSlopY = kDragSlopDefault,
  }) async {
    assert(kDragSlopDefault > kTouchSlop);
    final gesture =
        await startGesture(startLocation, pointer: pointer, buttons: buttons);

    final xSign = offset.dx.sign;
    final ySign = offset.dy.sign;

    final offsetX = offset.dx;
    final offsetY = offset.dy;

    final separateX = offset.dx.abs() > touchSlopX && touchSlopX > 0;
    final separateY = offset.dy.abs() > touchSlopY && touchSlopY > 0;

    if (separateY || separateX) {
      final offsetSlope = offsetY / offsetX;
      final inverseOffsetSlope = offsetX / offsetY;
      final slopSlope = touchSlopY / touchSlopX;
      final absoluteOffsetSlope = offsetSlope.abs();
      final signedSlopX = touchSlopX * xSign;
      final signedSlopY = touchSlopY * ySign;
      if (absoluteOffsetSlope != slopSlope) {
        // The drag goes through one or both of the extents of the edges of the box.
        if (absoluteOffsetSlope < slopSlope) {
          assert(offsetX.abs() > touchSlopX);
          // The drag goes through the vertical edge of the box.
          // It is guaranteed that the |offsetX| > touchSlopX.
          final diffY = offsetSlope.abs() * touchSlopX * ySign;

          // The vector from the origin to the vertical edge.
          await gesture.moveBy(Offset(signedSlopX, diffY));
          if (offsetY.abs() <= touchSlopY) {
            // The drag ends on or before getting to the horizontal extension of the horizontal edge.
            await gesture
                .moveBy(Offset(offsetX - signedSlopX, offsetY - diffY));
          } else {
            final diffY2 = signedSlopY - diffY;
            final diffX2 = inverseOffsetSlope * diffY2;

            // The vector from the edge of the box to the horizontal extension of the horizontal edge.
            await gesture.moveBy(Offset(diffX2, diffY2));
            await gesture.moveBy(
                Offset(offsetX - diffX2 - signedSlopX, offsetY - signedSlopY));
          }
        } else {
          assert(offsetY.abs() > touchSlopY);
          // The drag goes through the horizontal edge of the box.
          // It is guaranteed that the |offsetY| > touchSlopY.
          final diffX = inverseOffsetSlope.abs() * touchSlopY * xSign;

          // The vector from the origin to the vertical edge.
          await gesture.moveBy(Offset(diffX, signedSlopY));
          if (offsetX.abs() <= touchSlopX) {
            // The drag ends on or before getting to the vertical extension of the vertical edge.
            await gesture
                .moveBy(Offset(offsetX - diffX, offsetY - signedSlopY));
          } else {
            final diffX2 = signedSlopX - diffX;
            final diffY2 = offsetSlope * diffX2;

            // The vector from the edge of the box to the vertical extension of the vertical edge.
            await gesture.moveBy(Offset(diffX2, diffY2));
            await gesture.moveBy(
                Offset(offsetX - signedSlopX, offsetY - diffY2 - signedSlopY));
          }
        }
      } else {
        // The drag goes through the corner of the box.
        await gesture.moveBy(Offset(signedSlopX, signedSlopY));
        await gesture
            .moveBy(Offset(offsetX - signedSlopX, offsetY - signedSlopY));
      }
    } else {
      // The drag ends inside the box.
      await gesture.moveBy(offset);
    }
    await gesture.up();
  }

  /// The next available pointer identifier.
  ///
  /// This is the default pointer identifier that will be used the next time the
  /// [startGesture] method is called without an explicit pointer identifier.
  int nextPointer = 1;

  int _getNextPointer() {
    final result = nextPointer;
    nextPointer += 1;
    return result;
  }

  /// Creates gesture and returns the [TestGesture] object which you can use
  /// to continue the gesture using calls on the [TestGesture] object.
  ///
  /// You can use [startGesture] instead if your gesture begins with a down
  /// event.
  Future<TestGesture> createGesture({
    int? pointer,
    PointerDeviceKind kind = PointerDeviceKind.touch,
    int buttons = kPrimaryButton,
  }) async {
    return TestGesture(
      hitTester: hitTestOnBinding,
      dispatcher: sendEventToBinding,
      kind: kind,
      pointer: pointer ?? _getNextPointer(),
      buttons: buttons,
    );
  }

  /// Creates a gesture with an initial down gesture at a particular point, and
  /// returns the [TestGesture] object which you can use to continue the
  /// gesture.
  ///
  /// You can use [createGesture] if your gesture doesn't begin with an initial
  /// down gesture.
  Future<TestGesture> startGesture(
    Offset downLocation, {
    int? pointer,
    PointerDeviceKind kind = PointerDeviceKind.touch,
    int buttons = kPrimaryButton,
  }) async {
    final result = await createGesture(
      pointer: pointer,
      kind: kind,
      buttons: buttons,
    );
    await result.down(downLocation);
    return result;
  }

  /// Forwards the given location to the binding's hitTest logic.
  HitTestResult hitTestOnBinding(Offset location) {
    final result = HitTestResult();
    binding.hitTest(result, location);
    return result;
  }

  /// Forwards the given pointer event to the binding.
  Future<void> sendEventToBinding(
      PointerEvent event, HitTestResult? result) async {
    binding.dispatchEvent(event, result);
  }

  // GEOMETRY

  /// Returns the point at the center of the given widget.
  Offset getCenter(Finder finder) {
    return _getElementPoint(finder, (Size size) => size.center(Offset.zero));
  }

  /// Returns the point at the top left of the given widget.
  Offset getTopLeft(Finder finder) {
    return _getElementPoint(finder, (Size size) => Offset.zero);
  }

  /// Returns the point at the top right of the given widget. This
  /// point is not inside the object's hit test area.
  Offset getTopRight(Finder finder) {
    return _getElementPoint(finder, (Size size) => size.topRight(Offset.zero));
  }

  /// Returns the point at the bottom left of the given widget. This
  /// point is not inside the object's hit test area.
  Offset getBottomLeft(Finder finder) {
    return _getElementPoint(
        finder, (Size size) => size.bottomLeft(Offset.zero));
  }

  /// Returns the point at the bottom right of the given widget. This
  /// point is not inside the object's hit test area.
  Offset getBottomRight(Finder finder) {
    return _getElementPoint(
        finder, (Size size) => size.bottomRight(Offset.zero));
  }

  Offset _getElementPoint(
      Finder finder, Offset Function(Size size) sizeToPoint) {
    final element = finder.evaluate().single;
    final box = element.renderObject as RenderBox;
    return box.localToGlobal(sizeToPoint(box.size));
  }

  /// Returns the size of the given widget. This is only valid once
  /// the widget's render object has been laid out at least once.
  Size getSize(Finder finder) {
    final element = finder.evaluate().single;
    final box = element.renderObject as RenderBox;
    return box.size;
  }

  /// Returns the rect of the given widget. This is only valid once
  /// the widget's render object has been laid out at least once.
  Rect getRect(Finder finder) => getTopLeft(finder) & getSize(finder);
}

/// Variant of [WidgetController] that can be used in tests running
/// on a device.
///
/// This is used, for instance, by [FlutterDriver].
class LiveWidgetController extends WidgetController {
  /// Creates a widget controller that uses the given binding.
  LiveWidgetController(WidgetsBinding binding) : super(binding);

  @override
  Future<void> pump(Duration? duration) async {
    if (duration != null) await Future<void>.delayed(duration);
    binding.scheduleFrame();
    await binding.endOfFrame;
  }
}
