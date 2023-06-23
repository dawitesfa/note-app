import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo/screens/image_preview.dart';

// ignore: must_be_immutable
class StagerredImageGrid extends StatelessWidget {
  StagerredImageGrid(
      {super.key,
      required this.images,
      required this.height,
      required this.clickable});
  final List<File> images;
  final double height;
  final bool clickable;

  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return getStaggeredWidget(images, context) ?? const SizedBox();
  }

  Widget? getStaggeredWidget(List<File> files, BuildContext context) {
    File? firstItem;
    File? secondItem;
    List<File>? thirdItem;
    if (files.length == 1 || files.length % 3 == 1) {
      firstItem = files[0];
    }
    if (files.length == 2 || files.length % 3 == 2) {
      firstItem = files[0];
      secondItem = files[1];
    }
    if (files.length >= 3) {
      int reminder = files.length % 3;
      thirdItem = files.sublist(reminder);
    }

    Widget firstRow = const SizedBox();
    if (firstItem != null) {
      firstRow = secondItem == null
          ? getThumbnail(firstItem, context, false)
          : Row(
              children: [
                Expanded(child: getThumbnail(firstItem, context, true)),
                Expanded(
                  child: getThumbnail(secondItem, context, true),
                ),
              ],
            );
    }
    final secondRaw = thirdItem == null
        ? const SizedBox()
        : GridView.builder(
            itemCount: thirdItem.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) =>
                getThumbnail(thirdItem![index], context, false));
    return InkWell(
      onTap: clickable
          ? () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) =>
                      ImagePreview(images: images, activeIndex: currentIndex)));
            }
          : null,
      child: Column(
        children: [
          firstRow,
          const SizedBox(
            height: 2,
          ),
          secondRaw
        ],
      ),
    );
  }

  InkWell getThumbnail(File? img, context, scaled) {
    return InkWell(
      onTap: clickable
          ? () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ImagePreview(
                      images: images, activeIndex: images.indexOf(img!))));
            }
          : null,
      child: Image.file(
        img!,
        width: double.infinity,
        height: scaled ? height : null,
        fit: BoxFit.cover,
      ),
    );
  }
}
