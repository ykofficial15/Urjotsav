import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';


class SlideshowWidget extends StatefulWidget {
  @override
  _SlideshowWidgetState createState() => _SlideshowWidgetState();
}

class _SlideshowWidgetState extends State<SlideshowWidget> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String folderPath = 'slideshow';

    try {
      ListResult listResult = await storage.ref(folderPath).listAll();
      List<Reference> imageRefs = listResult.items;
      List<String> urls = await Future.wait(
        imageRefs.map((ref) => ref.getDownloadURL()).toList(),
      );

      setState(() {
        imageUrls = urls;
      });
    } catch (e) {
      print('Error fetching image URLs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return  Center(
        heightFactor: 9,
        child:Icon(Icons.image,)); 
      // Display a message when no images are available
      
    }

    return CarouselSlider.builder(
      itemCount: imageUrls.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: imageUrls[index],
          placeholder: (context, url) => Center(child:Icon(Icons.image)),
          errorWidget: (context, url, error) => Icon(Icons.error),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
      ),
    );
  }
}
