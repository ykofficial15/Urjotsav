import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<String> imageUrls = [];
  List<double> imageAspectRatios = [];

  @override
  void initState() {
    super.initState();
    // Call a function to retrieve the image URLs from Firebase storage
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    // Create a Firebase storage reference
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref();

    // Get a list of all the images in your storage bucket
    final imagesRef = storageRef.child('college/');
    final ListResult result = await imagesRef.listAll();

    // Store the image URLs and aspect ratios in their respective lists
    for (final Reference ref in result.items) {
      final imageUrl = await ref.getDownloadURL();

      final Image image = Image.network(imageUrl);
      final Completer<ui.Image> completer = Completer<ui.Image>();
      final ImageStreamListener listener =
          ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      });
      image.image.resolve(const ImageConfiguration()).addListener(listener);

      final ui.Image rawImage = await completer.future;
      final aspectRatio =
          rawImage.width.toDouble() / rawImage.height.toDouble();

      setState(() {
        imageUrls.add(imageUrl);
        imageAspectRatios.add(aspectRatio);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Life @PIEMR'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StaggeredGridView.countBuilder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            itemCount: imageUrls.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      final aspectRatio = imageAspectRatios[index];
                      final placeholderWidth =
                          MediaQuery.of(context).size.width / 2;
                      final placeholderHeight = placeholderWidth / aspectRatio;
                      return Container(
                        color: Colors.grey[300],
                        width: placeholderWidth,
                        height: placeholderHeight,
                        child:Center(child:CircularProgressIndicator())
                      );
                    },
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        ),
      ),
    );
  }
}
