// import '../model/hex_image.dart';
// import '../model/user.dart';
//
//
// class ImagesService {
//   User? _currentUser;
//   final List<HexImage> _images = [];
//
//   User? get currentUser => _currentUser;
//   List<HexImage> get images => List.unmodifiable(_images);
//
//   void login(String username, String password) {
//     _currentUser = User(
//       id: '1',
//       username: username,
//       createdAt: DateTime.now(),
//     );
//   }
//
//   void register(String username, String password) {
//     _currentUser = User(
//       id: '1',
//       username: username,
//       createdAt: DateTime.now(),
//     );
//   }
//
//   void logout() {
//     _currentUser = null;
//     _images.clear();
//   }
//
//   void createImage({
//     required String title,
//     String? description,
//     required int width,
//     required int height,
//   }) {
//     final image = HexImage(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       title: title,
//       description: description,
//       width: width,
//       height: height,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       userId: _currentUser!.id,
//     );
//
//     _images.add(image);
//   }
//
//   void updateImage(HexImage updatedImage) {
//     final index = _images.indexWhere((img) => img.id == updatedImage.id);
//     if (index != -1) {
//       _images[index] = updatedImage.copyWith(updatedAt: DateTime.now());
//     }
//   }
//
//   void deleteImage(String id) {
//     _images.removeWhere((img) => img.id == id);
//   }
//
//   HexImage? getImageById(String id) {
//     try {
//       return _images.firstWhere((img) => img.id == id);
//     } catch (e) {
//       return null;
//     }
//   }
// }