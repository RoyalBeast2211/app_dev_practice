import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CroppedImage extends StatefulWidget {
  final CroppedFile image;
  const CroppedImage({super.key, required this.image});

  @override
  State<CroppedImage> createState() => _CroppedImageState();
}

class _CroppedImageState extends State<CroppedImage> {
  String selectedShape = 'Original';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cropped Image'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedShape,
            items: <String>['Original', 'Circle', 'Oval'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedShape = newValue!;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: InteractiveViewer(
                child: getClippedImage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getClippedImage() {
    if (selectedShape == 'Original') {
      return Image(
        image: FileImage(
          File(widget.image.path),
        ),
      );
    } else {
      return Center(
        child: ClipPath(
          clipper: getClipper(),
          child: AspectRatio(
            aspectRatio: selectedShape == 'Oval' ? 4 / 3 : 1,
            child: Image(
              fit: BoxFit.cover,
              width: 300,
              height: selectedShape == 'Oval' ? 225 : 300,
              image: FileImage(
                File(widget.image.path),
              ),
            ),
          ),
        ),
      );
    }
  }

  CustomClipper<Path>? getClipper() {
    switch (selectedShape) {
      case 'Oval':
        return OvalClipper();
      case 'Circle':
        return CircleClipper();
      case 'Original':
      default:
        return null;
    }
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
