import 'package:intl/intl.dart';

class SensorData {
  final DateTime timestamp;
  final double temperature;
  final double humidity;
  final double duration;
  final String keterangan;

  SensorData({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.duration,
    required this.keterangan,
  });

  /// Convert dari JSON (Map) ke objek SensorData
  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      timestamp: DateTime.parse(json['timestamp']),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      keterangan: json['keterangan'] ?? '',
    );
  }


  /// Convert objek SensorData ke Map (untuk disimpan)
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
      'duration': duration,
      'keterangan': keterangan,
    };
  }

  /// Getter untuk format tanggal-timestamp (misal: 21 Jul 2025 – 13:50:00)
  String get timestampFormatted {
    return DateFormat('dd MMM yyyy – HH:mm:ss').format(timestamp);
  }
}
