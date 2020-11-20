import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Developed by Marcelo Glasberg (Aug 2019).
// For more info, see: https://pub.dartlang.org/packages/matrix4_transform

/// Helper class for easily creating Matrix4 transformations,
/// that you can use in Container's `transform` parameter,
/// and elsewhere.
///
/// Example:
///
/// ```
/// Container(
///    transform:
///      Matrix4Transform().rotateDegrees(45, origin: Offset(25, 25))
///                        .translate(x: 25)
///                        .toMatrix4(),
///    child: ...
/// );
/// ```
@immutable
class Matrix4Transform {
  final Matrix4 m;

  Matrix4Transform() : m = Matrix4.identity();

  Matrix4Transform.from(Matrix4 m) : m = m?.clone();

  Matrix4Transform._(this.m);

  Matrix4 get matrix4 => m.clone();

  /// Rotates by [angleRadians] radians, clockwise.
  /// If you define an origin it will have that point as the axis of rotation.
  Matrix4Transform rotate(double angleRadians, {Offset origin}) {
    if ((angleRadians == null) || (angleRadians == 0.0))
      return this;
    else if ((origin == null) || (origin.dx == 0.0 && origin.dy == 0.0))
      return Matrix4Transform._(m.clone()..rotateZ(angleRadians));
    else
      return Matrix4Transform._(m.clone()
        ..translate(origin.dx, origin.dy)
        ..multiply(Matrix4.rotationZ(angleRadians))
        ..translate(-origin.dx, -origin.dy));
  }

  /// Rotates by [angleDegrees] degrees (0 to 360 one turn), clockwise.
  /// If you define an origin it will have that point as the axis of rotation.
  Matrix4Transform rotateDegrees(double angleDegrees, {Offset origin}) =>
      rotate(_toRadians(angleDegrees), origin: origin);

  /// Rotates by [angleDegrees] degrees (0 to 360 one turn), clockwise.
  /// The axis of rotation will be the center of the object with the given size.
  Matrix4Transform rotateByCenterDegrees(double angleDegrees, Size size) =>
      rotateByCenter(_toRadians(angleDegrees), size);

  /// Rotates by [angleRadians] radians, clockwise.
  /// The axis of rotation will be the center of the object with the given size.
  Matrix4Transform rotateByCenter(double angleRadians, Size size) => rotate(
        angleRadians,
        origin: Offset(size.width / 2, size.height / 2),
      );

  /// Translates by [x] pixels (horizontal) and [y] pixels (vertical).
  /// Positive goes down/right.
  ///
  Matrix4Transform translate({double x = 0, double y = 0}) {
    x ??= 0;
    y ??= 0;

    return (x == 0 && y == 0) //
        ? this
        : Matrix4Transform._(m.clone()..leftTranslate(x, y));
  }

  /// Translates by [x] pixels (horizontal) and [y] pixels (vertical), but in
  /// respect to the original coordinate system, before the translates/scales.
  ///
  /// Example: If you rotate 30 degrees, and then call this method to translate
  /// x:10 it will translate by a distance of 10 pixels in 30 degrees.
  ///
  /// Example: If you resize if by 1.5, and then call this method to translate
  /// x:10 it will translate by 15 pixels.
  ///
  Matrix4Transform translateOriginalCoordinates({
    double x = 0,
    double y = 0,
  }) {
    x ??= 0;
    y ??= 0;

    return (x == 0 && y == 0) //
        ? this
        : Matrix4Transform._(m.clone()..translate(x, y));
  }

  /// Scales by [factor], keeping the aspect ratio.
  /// Gets bigger for >1.
  /// Smaller for <1.
  /// Same size for 1 (and passing null is the same as passing 1).
  /// No size for 0.
  /// Passing null is the same as passing 1.
  Matrix4Transform scale(double factor, {Offset origin}) =>
      scaleBy(x: factor, y: factor, origin: origin);

  /// Scales by a factor of [x] (horizontal) and [y] (vertical).
  /// Gets bigger for >1.
  /// Smaller for <1.
  /// Same size for 1 (and passing null is the same as passing 1).
  /// No size for 0.
  Matrix4Transform scaleBy({double x = 1, double y = 1, Offset origin}) {
    x ??= 1;
    y ??= 1;

    if (x == 1 && y == 1)
      return this;
    else if ((origin == null) || (origin.dx == 0.0 && origin.dy == 0.0))
      return Matrix4Transform._(//
          m.clone()..multiply(Matrix4.identity()..scale(x, y)));
    else
      return Matrix4Transform._(//
          m.clone()
            ..translate(origin.dx, origin.dy)
            ..multiply(Matrix4.identity()..scale(x, y))
            ..translate(-origin.dx, -origin.dy));
  }

  /// Scales by [factor] horizontally. Keeps the same vertical scale.
  /// Gets bigger for >1.
  /// Smaller for <1.
  /// Same size for 1 (and passing null is the same as passing 1).
  /// No size for 0.
  Matrix4Transform scaleHorizontally(double factor, {Offset origin}) =>
      scaleBy(x: factor, origin: origin);

  /// Scales by [factor] vertically. Keeps the same horizontal scale.
  /// Gets bigger for >1.
  /// Smaller for <1.
  /// Same size for 1 (and passing null is the same as passing 1).
  /// No size for 0.
  Matrix4Transform scaleVertically(double factor, {Offset origin}) =>
      scaleBy(y: factor, origin: origin);

  /// Translates by [x] pixels (horizontal) and [y] pixels (vertical).
  /// Positive goes down/right.
  Matrix4Transform translateOffset(Offset offset) {
    return (offset == null) //
        ? this
        : Matrix4Transform._(m.clone()..translate(offset.dx, offset.dy));
  }

  /// Translates up by [distance] pixels.
  Matrix4Transform up(double distance) => translate(y: -distance);

  /// Translates down by [distance] pixels.
  Matrix4Transform down(double distance) => translate(y: distance);

  /// Translates right by [distance] pixels.
  Matrix4Transform right(double distance) => translate(x: distance);

  /// Translates up left [distance] pixels.
  Matrix4Transform left(double distance) => translate(x: -distance);

  /// Translates by [distance] pixels to the [direction].
  /// The direction is in radians clockwise from the positive x-axis.
  Matrix4Transform direction(double directionRadians, double distance) =>
      translateOffset(Offset.fromDirection(directionRadians, distance));

  /// Translates by [distance] pixels to the [direction].
  /// The direction is in degrees (0 to 360 one turn) clockwise from the positive x-axis.
  Matrix4Transform directionDegrees(
    double directionDegrees,
    double distance,
  ) =>
      translateOffset(
        Offset.fromDirection(
          _toRadians(directionDegrees),
          distance,
        ),
      );

  /// Translates up and right by [distance] pixels of distance.
  Matrix4Transform upRight(double distance) => //
      direction(-pi / 4, distance);

  /// Translates up and left [distance] pixels.
  Matrix4Transform upLeft(double distance) => //
      direction(-pi * 3 / 4, distance);

  /// Translates down and right by [distance] pixels.
  Matrix4Transform downRight(double distance) => //
      direction(pi / 4, distance);

  /// Translates down and left by [distance] pixels.
  Matrix4Transform downLeft(double distance) => //
      direction(pi * 3 / 4, distance);

  Matrix4Transform flipDiagonally({Offset origin}) => //
      _flipDegrees(horizontal: 180, vertical: 180, origin: origin);

  Matrix4Transform flipHorizontally({Offset origin}) => //
      _flipDegrees(horizontal: 180, origin: origin);

  Matrix4Transform flipVertically({Offset origin}) => //
      _flipDegrees(vertical: 180, origin: origin);

  Matrix4Transform _flip({
    double horizontal = 0.0,
    double vertical = 0.0,
    Offset origin,
  }) {
    if (((horizontal == null) || (horizontal == 0.0)) //
        &&
        ((vertical == null) || (vertical == 0.0)))
      return this;
    else if ((origin == null) || (origin.dx == 0.0 && origin.dy == 0.0))
      return Matrix4Transform._(m.clone()
        ..rotateY(horizontal)
        ..rotateX(vertical));
    else
      return Matrix4Transform._(m.clone()
        ..translate(origin.dx, origin.dy)
        ..multiply(Matrix4.rotationY(horizontal))
        ..multiply(Matrix4.rotationX(vertical))
        ..translate(-origin.dx, -origin.dy));
  }

  /// Flips (with perspective) horizontally and vertically by [distance] pixels.
  Matrix4Transform _flipDegrees({
    double horizontal = 0.0,
    double vertical = 0.0,
    Offset origin,
  }) {
    return _flip(
      horizontal: _toRadians(horizontal),
      vertical: _toRadians(vertical),
      origin: origin,
    );
  }

  double _toRadians(double angleDegrees) => angleDegrees * pi / 180;
}

// ////////////////////////////////////////////////////////////////////////////

/// An interpolation between two [Matrix4Transform]s.
///
/// This class specializes the interpolation of [Tween<Matrix4Transform>] to be
/// appropriate for transformation matrices.
///
/// See [Tween] for a discussion on how to use interpolation objects.
class Matrix4TransformTween extends Tween<Matrix4Transform> {
  /// Creates a [Matrix4] tween.
  ///
  /// The [begin] and [end] properties must be non-null before the tween is
  /// first used, but the arguments can be null if the values are going to be
  /// filled in later.
  Matrix4TransformTween({Matrix4Transform begin, Matrix4Transform end})
      : super(begin: begin, end: end);

  @override
  Matrix4Transform lerp(double t) {
    return Matrix4Transform.from(
      Matrix4Tween(begin: begin.matrix4, end: end.matrix4).lerp(t),
    );
  }
}

// ////////////////////////////////////////////////////////////////////////////
