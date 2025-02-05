import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> images;
  final VoidCallback onAddImage;

  const ImageCarousel({
    super.key,
    required this.images,
    required this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: images.isEmpty
          ? Center(
              child: IconButton(
                icon: const Icon(Icons.add_photo_alternate, size: 48),
                onPressed: onAddImage,
              ),
            )
          : Stack(
              children: [
                PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      images[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: FloatingActionButton.small(
                    onPressed: onAddImage,
                    child: const Icon(Icons.add_photo_alternate),
                  ),
                ),
              ],
            ),
    );
  }
}
