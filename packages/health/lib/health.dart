library health;

import 'dart:async';
import 'dart:collection';
import 'dart:io' show Platform;

import 'package:carp_serializable/carp_serializable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'src/heath_data_types.dart';
part 'src/functions.dart';
part 'src/health_data_point.dart';
part 'src/health_value_types.dart';
part 'src/health_plugin.dart';
part 'src/workout_summary.dart';

part 'health.g.dart';
part 'health.json.dart';

/// Device types for health data sources.
/// Maps to Android Health Connect device type constants.
enum HealthDeviceType {
  unknown(0),
  watch(1),
  phone(2),
  scale(3),
  ring(4),
  headMounted(5),
  fitnessBand(6),
  chestStrap(7),
  smartDisplay(8);

  const HealthDeviceType(this.value);
  final int value;

  /// Convert from numeric value to enum
  static HealthDeviceType fromValue(int value) {
    return HealthDeviceType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => HealthDeviceType.unknown,
    );
  }

  /// Convert from string to enum
  static HealthDeviceType fromString(String value) {
    return HealthDeviceType.values.firstWhere(
      (type) => type.name == value.toLowerCase(),
      orElse: () => HealthDeviceType.unknown,
    );
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case HealthDeviceType.unknown:
        return "UNKNOWN";
      case HealthDeviceType.watch:
        return "WATCH";
      case HealthDeviceType.phone:
        return "PHONE";
      case HealthDeviceType.scale:
        return "SCALE";
      case HealthDeviceType.ring:
        return "RING";
      case HealthDeviceType.headMounted:
        return "HEAD_MOUNTED";
      case HealthDeviceType.fitnessBand:
        return "FITNESS_BAND";
      case HealthDeviceType.chestStrap:
        return "CHEST_STRAP";
      case HealthDeviceType.smartDisplay:
        return "SMART_DISPLAY";
    }
  }
}

/// Extract device type from device model string
/// Used to categorize iOS device models into device types
String extractDeviceTypeFromModel(String? deviceModel) {
  if (deviceModel == null || deviceModel.isEmpty) {
    return "iPhone";
  }
  
  final lowercased = deviceModel.toLowerCase();
  
  // Apple Watch detection
  if (lowercased.contains("watch")) {
    return "Watch";
  }
  
  // iPhone detection
  if (lowercased.contains("iphone")) {
    return "iPhone";
  }
  
  // iPad detection
  if (lowercased.contains("ipad")) {
    return "iPad";
  }
  
  // Mac detection
  if (lowercased.contains("mac")) {
    return "Mac";
  }
  
  // Scale detection
  if (lowercased.contains("scale") || 
      lowercased.contains("withings") ||
      lowercased.contains("fitbit aria")) {
    return "Scale";
  }
  
  // Ring detection (Oura, etc.)
  if (lowercased.contains("ring") || 
      lowercased.contains("oura")) {
    return "Ring";
  }
  
  // Head mounted devices (VR, AR, etc.)
  if (lowercased.contains("head") || 
      lowercased.contains("vr") || 
      lowercased.contains("ar")) {
    return "HeadMounted";
  }
  
  // Fitness band detection
  if (lowercased.contains("band") || 
      lowercased.contains("fitbit") ||
      lowercased.contains("mi band")) {
    return "FitnessBand";
  }
  
  // Chest strap detection
  if (lowercased.contains("chest") || 
      lowercased.contains("strap") ||
      lowercased.contains("polar") ||
      lowercased.contains("garmin")) {
    return "ChestStrap";
  }
  
  // Smart display detection
  if (lowercased.contains("display") || 
      lowercased.contains("tv")) {
    return "SmartDisplay";
  }
  
  // Default to iPhone if we can't determine the type
  return "iPhone";
}
