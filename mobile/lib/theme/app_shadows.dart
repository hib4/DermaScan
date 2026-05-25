import 'package:flutter/material.dart';

/// Elevation shadow definitions from DESIGN.md.
class AppShadows {
  AppShadows._();

  /// Level 0 — flat, no shadow.
  static const List<BoxShadow> flat = [];

  /// Level 1 — hairline border only, no shadow.
  static const List<BoxShadow> hairline = [];

  /// Level 2 — subtle layered drop-shadow (featured cards).
  static const List<BoxShadow> drop = [
    BoxShadow(offset: Offset(0, 84), blurRadius: 24, color: Color(0x00000000)),
    BoxShadow(offset: Offset(0, 54), blurRadius: 22, color: Color(0x03000000)),
    BoxShadow(offset: Offset(0, 30), blurRadius: 18, color: Color(0x0A000000)),
    BoxShadow(offset: Offset(0, 13), blurRadius: 13, color: Color(0x14000000)),
    BoxShadow(offset: Offset(0, 3), blurRadius: 7, color: Color(0x17000000)),
  ];

  /// Level 3 — stronger layered drop-shadow (pricing/modal emphasis).
  static const List<BoxShadow> dropStrong = [
    BoxShadow(offset: Offset(0, 84), blurRadius: 24, color: Color(0x00000000)),
    BoxShadow(offset: Offset(0, 54), blurRadius: 22, color: Color(0x03000000)),
    BoxShadow(offset: Offset(0, 30), blurRadius: 18, color: Color(0x0A000000)),
    BoxShadow(offset: Offset(0, 13), blurRadius: 13, color: Color(0x14000000)),
    BoxShadow(offset: Offset(0, 3), blurRadius: 7, color: Color(0x1F000000)),
  ];

  /// Level 4 — heavy modal shadow.
  static const List<BoxShadow> modal = [
    BoxShadow(offset: Offset(0, 24), blurRadius: 24, color: Color(0x42000000)),
    BoxShadow(offset: Offset(0, 6), blurRadius: 13, color: Color(0x4A000000)),
  ];

  /// Lookup table for elevation levels 0–4.
  static List<BoxShadow> byLevel(int level) {
    return switch (level) {
      0 => flat,
      1 => hairline,
      2 => drop,
      3 => dropStrong,
      4 => modal,
      _ => flat,
    };
  }
}
