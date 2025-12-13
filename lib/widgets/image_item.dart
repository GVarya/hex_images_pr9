// import 'package:flutter/material.dart';
// import '../model/hex_image.dart';
//
// class ImageItem extends StatelessWidget {
//   final HexImage image;
//   final VoidCallback onTap;
//   final VoidCallback onDelete;
//
//   const ImageItem({
//     Key? key,
//     required this.image,
//     required this.onTap,
//     required this.onDelete,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       elevation: 2,
//       child: ListTile(
//         leading: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: Center(
//             child: Icon(
//               Icons.hexagon_outlined,
//               color: Colors.blue.shade400,
//             ),
//           ),
//         ),
//         title: Text(
//           image.title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Размер: ${image.width} × ${image.height}'),
//             if (image.description != null && image.description!.isNotEmpty)
//               Text(
//                 image.description!,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 12,
//                 ),
//               ),
//             Text(
//               _formatDate(image.updatedAt),
//               style: TextStyle(
//                 color: Colors.grey.shade500,
//                 fontSize: 10,
//               ),
//             ),
//           ],
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.delete, color: Colors.red),
//           onPressed: onDelete,
//           tooltip: 'Удалить',
//         ),
//         onTap: onTap,
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     return 'Обновлено: ${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
//   }
// }

import 'package:flutter/material.dart';
import '../model/hex_image.dart';

class ImageItem extends StatelessWidget {
  final HexImage image;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onPreview;

  const ImageItem({
    Key? key,
    required this.image,
    required this.onTap,
    required this.onDelete,
    this.onPreview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.blue.shade300),
          ),
          child: Icon(
            Icons.hexagon_outlined,
            color: Colors.blue.shade600,
          ),
        ),
        title: Text(
          image.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${image.width}×${image.height} • ${image.createdAt.day}.${image.createdAt.month}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onPreview != null)
                IconButton(
                  icon: Icon(Icons.preview, size: 20, color: Colors.blue.shade600),
                  onPressed: onPreview,
                  tooltip: 'Просмотр',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Удалить',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
