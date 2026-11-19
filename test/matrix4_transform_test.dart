import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

void main() {
  void expectMatrix(Matrix4 actual, Matrix4 expected) {
    for (var index = 0; index < 16; index++) {
      expect(
        actual.storage[index],
        closeTo(expected.storage[index], 1e-10),
        reason: 'entry $index',
      );
    }
  }

  test('rotation about a pivot keeps that pivot fixed', () {
    final actual = Matrix4Transform().rotate(
      pi / 2,
      origin: const Offset(4, 5),
    );
    expectMatrix(
      actual.matrix4,
      Matrix4.fromList([0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 9, 1, 0, 1]),
    );
    expect(
      MatrixUtils.transformPoint(actual.matrix4, const Offset(4, 5)),
      const Offset(4, 5),
    );
  });

  test('nonuniform scaling preserves the original implicit Z scale', () {
    expectMatrix(
      Matrix4Transform().scaleBy(x: 2, y: 3).matrix4,
      Matrix4.diagonal3Values(2, 3, 2),
    );
    expectMatrix(
      Matrix4Transform().scaleBy(x: 0, y: -3).matrix4,
      Matrix4.diagonal3Values(0, -3, 0),
    );
  });

  test('scaling around a pivot preserves translation, Z and W', () {
    final actual = Matrix4Transform().scaleBy(
      x: 2,
      y: 3,
      origin: const Offset(4, 5),
    );
    expectMatrix(
      actual.matrix4,
      Matrix4.fromList([2, 0, 0, 0, 0, 3, 0, 0, 0, 0, 2, 0, -4, -10, 0, 1]),
    );
  });

  test(
    'world and original-coordinate translations use different multiplication orders',
    () {
      final rotated = Matrix4Transform().rotate(pi / 2);
      expect(
        MatrixUtils.transformPoint(
          rotated.translate(x: 2, y: 3).matrix4,
          Offset.zero,
        ),
        const Offset(2, 3),
      );
      final original = rotated.translateOriginalCoordinates(x: 2, y: 3).matrix4;
      expect(original.entry(0, 3), closeTo(-3, 1e-10));
      expect(original.entry(1, 3), closeTo(2, 1e-10));
      expectMatrix(
        rotated.translateOffset(const Offset(2, 3)).matrix4,
        original,
      );
    },
  );

  test(
    'combined transformations preserve projective components without mutating the source',
    () {
      final source = Matrix4.fromList(
        List<double>.generate(16, (i) => i + 1.0),
      );
      final snapshot = source.clone();
      final actual = Matrix4Transform.from(source)
          .scaleBy(x: 2, y: -3)
          .translateOriginalCoordinates(x: 4, y: 5)
          .translate(x: 6, y: 7);
      final expected =
          Matrix4.translationValues(6, 7, 0) *
          source *
          Matrix4.diagonal3Values(2, -3, 2) *
          Matrix4.translationValues(4, 5, 0);
      expectMatrix(actual.matrix4, expected);
      expectMatrix(source, snapshot);
    },
  );

  test('pivoted flips preserve the original X, Y and Z axes', () {
    const origin = Offset(4, 5);
    expectMatrix(
      Matrix4Transform().flipHorizontally(origin: origin).matrix4,
      Matrix4.fromList([-1, 0, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 8, 0, 0, 1]),
    );
    expectMatrix(
      Matrix4Transform().flipVertically(origin: origin).matrix4,
      Matrix4.fromList([1, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1, 0, 0, 10, 0, 1]),
    );
    expectMatrix(
      Matrix4Transform().flipDiagonally(origin: origin).matrix4,
      Matrix4.fromList([-1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 8, 10, 0, 1]),
    );
  });

  test('zero operations return the same immutable transform', () {
    final transform = Matrix4Transform();
    expect(identical(transform.rotate(0), transform), isTrue);
    expect(identical(transform.scaleBy(), transform), isTrue);
    expect(identical(transform.translate(), transform), isTrue);
    expect(
      identical(transform.translateOriginalCoordinates(), transform),
      isTrue,
    );
  });
}
