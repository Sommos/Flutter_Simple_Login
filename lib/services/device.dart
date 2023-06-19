
class Device {
  String name;
  String id;
  bool isConnected;
  bool isRunning;

  Device({
    required this.name,
    required this.id,
    this.isConnected = false,
    this.isRunning = false,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      name: json['name'],
      id: json['id'],
      isConnected: json['isConnected'],
      isRunning: json['isRunning'],
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'isConnected': isConnected,
      'isRunning': isRunning,
    };
  }
}