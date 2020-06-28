class Wheel {
  double frontDistance;
  double backDistance;

  Wheel(this.frontDistance, this.backDistance);

  double get diff => (frontDistance - backDistance).abs();

  bool get isToeIn => frontDistance > backDistance;

  factory Wheel.fromJson(Map<String, dynamic> json) {
    return Wheel(
      (json['front'] ?? 0.0) as double,
      (json['back'] ?? 0.0) as double,
    );
  }

  Map<String, double> toJson() {
    return {
      'front': frontDistance,
      'back': backDistance,
    };
  }
}

enum WheelSide { FRONT_LEFT, FRONT_RIGHT, REAR_LEFT, REAR_RIGHT }
