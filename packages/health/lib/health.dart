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
