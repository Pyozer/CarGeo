class Wheel {
  double frontDistance;
  double backDistance;

  Wheel(this.frontDistance, this.backDistance);

  double get diff => (frontDistance - backDistance).abs();

  bool get isToeIn => frontDistance > backDistance;
}

enum WheelSide { FRONT_LEFT, FRONT_RIGHT, REAR_LEFT, REAR_RIGHT }
