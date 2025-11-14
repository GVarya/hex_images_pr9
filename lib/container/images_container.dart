// import 'package:flutter/material.dart';
// import '../services/images_service.dart';
//
// class ImagesContainer extends InheritedWidget {
//   final ImagesService imagesService;
//
//   const ImagesContainer({
//     Key? key,
//     required this.imagesService,
//     required Widget child,
//   }) : super(key: key, child: child);
//
//   static ImagesContainer of(BuildContext context) {
//     final ImagesContainer? result =
//     context.dependOnInheritedWidgetOfExactType<ImagesContainer>();
//     assert(result != null, 'No ImagesContainer found in context');
//     return result!;
//   }
//
//   @override
//   bool updateShouldNotify(ImagesContainer oldWidget) {
//     return imagesService != oldWidget.imagesService;
//   }
// }