import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Dibujar fondo
    canvas.drawRect(Offset.zero & size, paint);

    // Dibujar círculo exterior
    paint.color = Colors.blue.shade100;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * 0.45,
      paint,
    );

    // Dibujar círculo interior
    paint.color = Colors.blue;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * 0.35,
      paint,
    );

    // Dibujar agujas de crochet cruzadas
    paint.color = Colors.white;
    paint.strokeWidth = size.width * 0.06;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;

    // Primera aguja
    final path1 = Path()
      ..moveTo(size.width * 0.3, size.height * 0.3)
      ..lineTo(size.width * 0.7, size.height * 0.7);

    // Segunda aguja
    final path2 = Path()
      ..moveTo(size.width * 0.3, size.height * 0.7)
      ..lineTo(size.width * 0.7, size.height * 0.3);

    // Dibujar las agujas con un borde más oscuro
    paint.color = Colors.blue.shade900;
    paint.strokeWidth = size.width * 0.08;
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);

    // Dibujar las agujas en blanco
    paint.color = Colors.white;
    paint.strokeWidth = size.width * 0.06;
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);

    // Añadir pequeños círculos en las intersecciones
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.04,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<void> generateIcon() async {
  // Obtener el directorio temporal
  final directory = await getTemporaryDirectory();
  final iconPath = '${directory.path}/app_icon.png';
  final foregroundPath = '${directory.path}/app_icon_foreground.png';

  final size = Size(1024, 1024);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  AppIconPainter().paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  if (byteData != null) {
    final bytes = byteData.buffer.asUint8List();

    // Guardar archivos en el directorio temporal
    await File(iconPath).writeAsBytes(bytes);
    await File(foregroundPath).writeAsBytes(bytes);

    print('Iconos generados exitosamente en:');
    print('Icon: $iconPath');
    print('Foreground: $foregroundPath');
  }
}

// Función para compartir el icono
Future<void> shareIcon() async {
  final directory = await getTemporaryDirectory();
  final iconPath = '${directory.path}/app_icon.png';

  if (await File(iconPath).exists()) {
    // Aquí puedes implementar la lógica para compartir el archivo
    // Por ejemplo, usando share_plus:
    // await Share.shareFiles([iconPath], text: 'App Icon');
  }
}
