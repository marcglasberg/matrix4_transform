[![pub package](https://img.shields.io/pub/v/matrix4_transform.svg)](https://pub.dartlang.org/packages/matrix4_transform)

# matrix4_transform

Have you noticed the `transform` parameter in the `Container` and `Transform` widgets, 
that let you move, rotate, resize and flip?

This package is a helper math class that makes it easy to create Matrix4 transformations.

![](./example/lib/animated_align_positioned.gif)

Example:

    // Rotates the Container 45 degrees and then
    // translates 25 pixels to the right. 
    Container(
       transform:
         Matrix4Transform()
           .rotateDegrees(45, origin: Offset(25, 25))
           .translate(x: 25)
           .matrix4,
       child: ...
    );
    
To see it in action, run the example in the [example tab](https://pub.dartlang.org/packages/matrix4_transform#-example-tab-).    

## How to use it 

`Matrix4Transform` is **immutable** (in contrast, Matrix4 is mutable).

First create a `Matrix4Transform`:

    Matrix4Transform();
    
Then call the methods to transform it. For example: 

    Matrix4Transform()
       .scale(1.5)
       .upRight(35)
       .rotate(pi/2);
       
In the end, call `matrix4`: 

    Matrix4 myMatrix 
       = Matrix4Transform()
         .scale(1.5)
         .upRight(35)
         .rotate(pi/2)
         .matrix4;                        
       
Note: The transformations will be applied in order, and their order may change the end result.

If you already have a matrix4 and want to further transform it, you can use the `from` constructor:
       
    Matrix4 myMatrix = ...;
    
    var myTransform = Matrix4Transform.from(myMatrix);

## Methods you can use

- `rotate(double angleRadians, {Offset origin})`
- `rotateDegrees(double angleDegrees, {Offset origin})`
- `rotateByCenterDegrees(double angleDegrees, Size size)`
- `rotateByCenter(_toRadians(angleDegrees), size)`  
- `translate({double x = 0, double y = 0})`
- `translateOriginalCoordinates({double x = 0, double y = 0})`
- `scale(double factor, {Offset origin})`
- `scaleBy({double x = 1, double y = 1, Offset origin})`
- `scaleHorizontally(double factor)`
- `scaleVertically(double factor)`
- `translateOffset(Offset offset)`
- `up(double distance)`
- `down(double distance)`
- `right(double distance)`
- `left(double distance)`
- `direction(double directionRadians, double distance)`
- `directionDegrees(double directionDegrees, double distance)`
- `upRight(double distance)`
- `upLeft(double distance)`
- `downRight(double distance)`
- `downLeft(double distance)`
- `flipDiagonally({Offset origin})`
- `flipHorizontally({Offset origin})`
- `flipVertically({Offset origin})`

And, of course:

- `Matrix4 toMatrix4`

## Tween

A `Matrix4TransformTween` is provided in this package, and can be used in animations.

## Animate it

A `Matrix4Transform` can be used to animate:

* `AlignPositioned` or `AnimatedAlignPositioned` widgets 
from the <a href="https://pub.dev/packages/align_positioned">AlignPositioned</a> package,
that accept a `Matrix4Transform` directly. The center of rotation/scale can be defined
by their `alignment` parameter. 

* Any widget that accepts a Matrix4 transformation parameter, like `Container`, or `AnimatedContainer`.
Note: Since `Matrix4Tween` will not animate linearly as you'd expect, it's possible
that the intermediary transformations will be "strange", although the start and end should be correct.

***

*Special thanks to Martin Kamleithner and Simon Lightfoot.*

*The Flutter packages I've authored:* 
* <a href="https://pub.dev/packages/async_redux">async_redux</a>
* <a href="https://pub.dev/packages/provider_for_redux">provider_for_redux</a>
* <a href="https://pub.dev/packages/i18n_extension">i18n_extension</a>
* <a href="https://pub.dev/packages/align_positioned">align_positioned</a>
* <a href="https://pub.dev/packages/network_to_file_image">network_to_file_image</a>
* <a href="https://pub.dev/packages/matrix4_transform">matrix4_transform</a> 
* <a href="https://pub.dev/packages/back_button_interceptor">back_button_interceptor</a>
* <a href="https://pub.dev/packages/indexed_list_view">indexed_list_view</a> 
* <a href="https://pub.dev/packages/animated_size_and_fade">animated_size_and_fade</a>
* <a href="https://pub.dev/packages/assorted_layout_widgets">assorted_layout_widgets</a>

---<br>_Marcelo Glasberg:_<br>_https://github.com/marcglasberg_<br>
_https://twitter.com/glasbergmarcelo_<br>
_https://stackoverflow.com/users/3411681/marcg_<br>
_https://medium.com/@marcglasberg_<br>
