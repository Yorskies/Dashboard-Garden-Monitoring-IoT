// lib/models/sensor_data.dart
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
}
