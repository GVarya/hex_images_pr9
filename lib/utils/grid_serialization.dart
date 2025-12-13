
import 'dart:ui';

import 'package:flutter/material.dart';


class GridSerialization {

  static List<List<String>> serializeGrid(List<List<Color>> grid) {
    return grid
        .map(
          (row) => row
          .map(
            (color) =>
        '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      )
          .toList(),
    )
        .toList();
  }


  static List<List> deserializeGrid(dynamic data) {
    if (data is! List) return [];

    return (data as List)
        .map(
          (row) {
        if (row is! List) return [];
        return (row as List)
            .map((colorHex) {
          try {
            final hex = colorHex.toString().replaceFirst('#', '');
            return Color(int.parse('0xFF$hex'));
          } catch (e) {
            return Colors.white;
          }
        })
            .toList();
      },
    )
        .toList();
  }

  static void exampleSave() {
    // В ImageEditorScreen._saveProject():
    // final serialized = GridSerialization.serializeGrid(grid);
    // imageOps.updateImage(
    //   image.copyWith(data: serialized),
    // );
  }

  static void exampleLoad() {
    // В ImageEditorScreen._loadImageData():
    // final grid = GridSerialization.deserializeGrid(image.data);
    // setState(() {
    //   this.grid = grid;
    // });
  }
}