// import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  int translate = 0;
  bool canDrag;
  final double maxSlide = 300.0;
  Widget myContainer1 = Container(
    color: Colors.blue,
  );
  Widget myContainer2 = Container(
    color: Colors.yellow,
  );
  AnimationController animationController;

  void _incrementCounter() {
    setState(() {
      _counter++;
      translate++;
    });
  }

  @override
  void initState() {
    super.initState();
    canDrag = true;
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    // animationController.forward();
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();
  double minDragStartEdge = 100;
  double maxDragStartEdge = 200;
  void _onHorizontalDragStart(DragStartDetails dragStartDetails) {
    bool isDragOpenFromLeft =
        (dragStartDetails.globalPosition.dx < minDragStartEdge &&
            animationController.isDismissed);
    // print(dragStartDetails.globalPosition.dx);
    bool isDragCloseFromRight = (animationController.isCompleted &&
        dragStartDetails.globalPosition.dx > maxDragStartEdge);
    // print(maxDragStartEdge);
    canDrag = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails dragUpdateDetails) {
    if (canDrag) {
      // print(maxSlide * animationController.value - 1);
      double delta = dragUpdateDetails.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onHorizontalDragEnd(DragEndDetails dragEndDetails) {
    if (animationController.isCompleted || animationController.isDismissed) {
      return;
    }
    if (dragEndDetails.velocity.pixelsPerSecond.dx.abs() >= 365) {
      // print(dragEndDetails.velocity.pixelsPerSecond.dx);
      double visualVelocity = dragEndDetails.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      // close();
      print('hai');
    } else {
      // open();
      print('hai,hai');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onHorizontalDragStart: _onHorizontalDragStart,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        onTap: toggle,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) => Stack(children: [
            Transform.translate(
              offset: Offset(maxSlide * animationController.value - 1, 0.0),
              child: Transform(
                  transform: Matrix4.identity()
                    ..rotateY(math.pi / 2 * (1 - animationController.value)),
                  alignment: Alignment.centerRight,
                  child: myContainer1),
            ),
            Transform.translate(
              offset: Offset(maxSlide * animationController.value, 0.0),
              child: Transform(
                  transform: Matrix4.identity()
                    // case1:animation to right sde only:>
                    // ..translate(maxSlide * animationController.value)
                    // ..scale(1 - (0.3 * animationController.value)),
                    // alignment: Alignment.centerLeft,
                    // case2;animation in y axis with 3d effect
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(-math.pi / 2 * animationController.value),
                  child: myContainer2),
            )

            // Column(
            //   // mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text(
            //       'You have pushed the button this many times:',
            //     ),
            //     Text(
            //       '$_counter',
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //   ],
            // ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
