import 'package:adaptive_golden_test/adaptive_golden_test.dart';
import 'package:flutter/material.dart';

enum Device {
  iPhone8(
    size: const Size(375, 667),
    pixelDensity: 2.0,
    safeAreaPadding: EdgeInsets.zero,
    keyboardSize: const Size(375, 218),
    borderRadius: BorderRadius.zero,
    targetPlatform: TargetPlatform.iOS,
  ),
  iPhone13(
    size: const Size(390, 844),
    pixelDensity: 3.0,
    safeAreaPadding: const EdgeInsets.only(top: 47, bottom: 34),
    keyboardSize: const Size(390, 302),
    borderRadius: BorderRadius.all(Radius.circular(48)),
    homeIndicator: const HomeIndicatorData(8, Size(135, 5)),
    notchSize: const Size(154, 32),
    targetPlatform: TargetPlatform.iOS,
  ),
  pixel5(
    size: const Size(360, 764),
    pixelDensity: 3.0,
    safeAreaPadding: const EdgeInsets.only(top: 24),
    keyboardSize: const Size(360, 297),
    borderRadius: BorderRadius.all(Radius.circular(32)),
    homeIndicator: const HomeIndicatorData(8, Size(72, 2)),
    targetPlatform: TargetPlatform.android,
    punchHole: const PunchHoleData(Offset(12, 12), 25),
  ),
  iPadPro(
    size: const Size(1366, 1024),
    pixelDensity: 2.0,
    safeAreaPadding: const EdgeInsets.only(top: 24, bottom: 20),
    keyboardSize: const Size(1366, 420),
    borderRadius: BorderRadius.all(Radius.circular(24)),
    homeIndicator: const HomeIndicatorData(8, Size(315, 5)),
    targetPlatform: TargetPlatform.iOS,
  ),
  desktop(
    size: const Size(1920, 1080),
    pixelDensity: 1.0,
    safeAreaPadding: EdgeInsets.zero,
    borderRadius: BorderRadius.zero,
    targetPlatform: TargetPlatform.linux,
  ),
  ;

  const Device({
    required this.size,
    required this.pixelDensity,
    required this.targetPlatform,
    required this.borderRadius,
    required this.safeAreaPadding,
    this.keyboardSize,
    this.notchSize,
    this.punchHole,
    this.homeIndicator,
  });

  final Size size;
  final double pixelDensity;
  final Size? keyboardSize;
  final Size? notchSize;
  final PunchHoleData? punchHole;
  final HomeIndicatorData? homeIndicator;
  final TargetPlatform targetPlatform;
  final BorderRadius borderRadius;
  final EdgeInsets safeAreaPadding;
}
