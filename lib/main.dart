import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Pixle button')),
        body: Wrap(
          children: [
            PixelButton(
              onPressed: () {},
              width: 200,
              hight: 200,
              strokeWidth: 3,
              child: Text(
                'hello',
                style: TextStyle(fontSize: 20),
              ),
            ),
            PixelButton(
              onPressed: () {},
              width: 100,
              hight: 50,
              buttonColor: Colors.red,
              strokeWidth: 3,
              child: Text(
                'hello',
                style: TextStyle(fontSize: 20),
              ),
            ),
            PixelButton(
              onPressed: () {},
              width: 200,
              hight: 90,
              buttonColor: Colors.amber,
              strokeWidth: 3,
              child: Text(
                'hello',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ));
  }
}

class PixelButton extends StatefulWidget {
  final double width;
  final double hight;
  final Color buttonColor;
  final double strokeWidth;
  final Function onPressed;
  final Widget child;
  PixelButton({
    this.width = 100,
    this.hight = 50,
    this.buttonColor = Colors.blue,
    this.strokeWidth = 1,
    @required this.onPressed,
    @required this.child,
  });

  @override
  _PixelButtonState createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  double width;
  double hight;
  bool show = true;

  @override
  void initState() {
    hight = widget.hight;
    width = widget.width;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('object2');

    return Container(
      width: width,
      height: hight,
      margin: EdgeInsets.all(20),
      child: ClipRect(
        child: Stack(
          children: [
            if (show)
              RepaintBoundary(
                child: CustomPaint(
                  size: Size(width, hight),
                  painter: ButtonPainter(
                    strokeW: widget.strokeWidth,
                    color: widget.buttonColor,
                  ),
                ),
              ),
            Positioned(
              right: show ? null : 0,
              bottom: show ? null : 0,
              child: InkWell(
                onTap: widget.onPressed,
                onHighlightChanged: (value) {
                  setState(() {
                    show = !value;
                  });
                },
                child: Container(
                    width: width * 0.9,
                    height: hight * 0.9,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: widget.buttonColor,
                        border: Border.all(width: widget.strokeWidth),
                        borderRadius: BorderRadius.circular(2)),
                    child: widget.child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonPainter extends CustomPainter {
  final double strokeW;
  final Color color;
  final Color strokeColor;

  ButtonPainter({
    @required this.strokeW,
    @required this.color,
    this.strokeColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Path path_1 = Path();
    path_1.moveTo(size.width * 0.9, size.height * 0.9 - strokeW);
    path_1.lineTo(size.width * 0.9, strokeW);
    path_1.lineTo(size.width - strokeW, size.height * 0.1 + strokeW);
    path_1.lineTo(size.width - strokeW, size.height - strokeW);
    path_1.close();

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.1 + strokeW, size.height - strokeW);
    path_2.lineTo(0, size.height * 0.9 - strokeW);
    path_2.lineTo(size.width * 0.9, size.height * 0.9);
    path_2.lineTo(size.width - strokeW, size.height - strokeW);

    path_2.close();

    Paint paint2Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW * 2
      ..strokeCap = StrokeCap.round;
    paint2Stroke.color = strokeColor ?? Colors.black;
    canvas.drawPath(path_2, paint2Stroke);

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = color;
    canvas.drawPath(path_2, paint2Fill);

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW * 2
      ..strokeCap = StrokeCap.round;
    paint1Stroke.color = strokeColor ?? Colors.black;
    canvas.drawPath(path_1, paint1Stroke);

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
