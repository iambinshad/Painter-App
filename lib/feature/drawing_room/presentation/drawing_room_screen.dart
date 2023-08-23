import 'package:flutter/material.dart';
import 'package:painter_app/core/theme/app_color.dart';
import 'package:painter_app/feature/drawing_room/model/drawing_point.dart';

class DrawingRoomScreen extends StatefulWidget {
  const DrawingRoomScreen({super.key});

  @override
  State<DrawingRoomScreen> createState() => _DrawingRoomScreenState();
}

class _DrawingRoomScreenState extends State<DrawingRoomScreen> {
  @override
  var avaiableColor = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown,
  ];
  DrawingPoint? currentDrawingPoint;
  var historyDrawingPoint = <DrawingPoint>[];
  var drawingPoint = <DrawingPoint>[];
  var selectedColor = Colors.black;
  var selectedWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                currentDrawingPoint = DrawingPoint(
                  color: selectedColor,
                  width: selectedWidth,
                  id: DateTime.now().microsecondsSinceEpoch,
                  offsets: [details.localPosition],
                );
                if (currentDrawingPoint == null) return;
                drawingPoint.add(currentDrawingPoint!);
                historyDrawingPoint = List.of(drawingPoint);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                if (currentDrawingPoint == null) return;
                currentDrawingPoint = currentDrawingPoint?.copyWith(
                    offsets: currentDrawingPoint!.offsets
                      ..add(details.localPosition));
                drawingPoint.last = currentDrawingPoint!;
                historyDrawingPoint = List.of(drawingPoint);
              });
            },
            onPanEnd: (_) {
              currentDrawingPoint = null;
            },
            child: CustomPaint(
              painter: DrawingPainter(drawingPoints: drawingPoint),
              child: const SizedBox(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 16,
              right: 16,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  separatorBuilder: (_, __) {
                    return const SizedBox(
                      width: 8,
                    );
                  },
                  itemCount: avaiableColor.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedColor = avaiableColor[index];
                      });
                    },
                    child: Container(
                      foregroundDecoration: BoxDecoration(
                          border: selectedColor == avaiableColor[index]
                              ? Border.all(
                                  color: AppColor.primaryColor, width: 4)
                              : null,
                          shape: BoxShape.circle),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: avaiableColor[index], shape: BoxShape.circle),
                    ),
                  ),
                ),
              )),
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 0,
            bottom: 150,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: selectedWidth,
                min: 1,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    selectedWidth = value;
                  });
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "Undo",
            onPressed: () {
              if (drawingPoint.isNotEmpty && historyDrawingPoint.isNotEmpty) {
                setState(() {
                  drawingPoint.removeLast();
                });
              }
            },
            child: const Icon(Icons.undo),
          ),
          const SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            heroTag: "Redo",
            onPressed: () {
              if (drawingPoint.length < historyDrawingPoint.length) {
                setState(() {
                  final index = drawingPoint.length;
                  drawingPoint.add(historyDrawingPoint[index]);
                });
              }
            },
            child: const Icon(Icons.redo),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  DrawingPainter({required this.drawingPoints});
  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < drawingPoint.offsets.length; i++) {
        var notLastOffset = i != drawingPoint.offsets.length - 1;
        if (notLastOffset) {
          final current = drawingPoint.offsets[i];
          final next = drawingPoint.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        } else {
          //do nothing!
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
