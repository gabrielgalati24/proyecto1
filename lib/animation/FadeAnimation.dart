// import 'package:flutter/material.dart';
// import 'package:simple_animations/simple_animations.dart';

// class FadeAnimation extends StatefulWidget {
//   final double delay;
//   final Widget child;

//   FadeAnimation(this.delay, this.child);

//   @override
//   _FadeAnimationState createState() => _FadeAnimationState();
// }

// class _FadeAnimationState extends State<FadeAnimation> {
//   late Animation<double> size;

//   @override
//   void initState() {
//     // connect tween and controller and apply to animation variable
//     size = 0.0.tweenTo(200.0).animatedBy(controller);

//     controller.play(); // start the animation playback

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size.value, // use animation variable's value
//       height: size.value, // use animation variable's value
//       color: Colors.red,
//     );
//   }
// }
