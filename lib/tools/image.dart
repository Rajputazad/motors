import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageGallery extends StatelessWidget {
  final List<String> images;
  final int initialIndex;
  final String car;

  const FullScreenImageGallery(
      {super.key,
      required this.images,
      required this.initialIndex,
     required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), // Replace with your desired app bar color
        title:  Text(car),
        elevation: 0.1,
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        color: Colors.white,
        child: PhotoViewGallery.builder(
          itemCount: images.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(images[index]),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          pageController: PageController(initialPage: initialIndex),
        ),
      ),
    );
  }
}
