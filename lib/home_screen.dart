import 'dart:convert';

import 'package:GeoCar/card.dart';
import 'package:GeoCar/util.dart';
import 'package:GeoCar/wheel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final SharedPreferences prefs;

  const HomeScreen({Key key, this.prefs}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Wheel frontLeft = Wheel(0.0, 0.0);
  Wheel frontRight = Wheel(0.0, 0.0);
  Wheel rearLeft = Wheel(0.0, 0.0);
  Wheel rearRight = Wheel(0.0, 0.0);
  double wheelSize = 41.5;

  @override
  void initState() {
    super.initState();
    initSavedValues();
  }

  void initSavedValues() {
    frontLeft = jsonToWheel(widget.prefs.getString('${WheelSide.FRONT_LEFT}'));
    frontRight = jsonToWheel(
      widget.prefs.getString('${WheelSide.FRONT_RIGHT}'),
    );
    rearLeft = jsonToWheel(widget.prefs.getString('${WheelSide.REAR_LEFT}'));
    rearRight = jsonToWheel(widget.prefs.getString('${WheelSide.REAR_RIGHT}'));
    wheelSize = widget.prefs.getDouble('wheelSize') ?? 41.5;
  }

  Wheel getWheel(WheelSide side) {
    if (side == WheelSide.FRONT_LEFT) return frontLeft;
    if (side == WheelSide.FRONT_RIGHT) return frontRight;
    if (side == WheelSide.REAR_LEFT) return rearLeft;
    return rearRight;
  }

  void _onFormEdit(double value, WheelSide side, bool isBack) {
    final wheel = getWheel(side);
    setState(() {
      if (isBack) {
        wheel.backDistance = value;
      } else {
        wheel.frontDistance = value;
      }
    });
    widget.prefs.setString('$side', json.encode(wheel));
  }

  double _calculWheelAngle(WheelSide side) {
    final wheel = getWheel(side);
    final distB = calcMissingDist(wheelSize, wheel.diff);
    final angle = roundDecimal(calcAngle(wheelSize, wheel.diff, distB), 3);
    if (wheel.isToeIn) return angle * -1;
    return angle;
  }

  double _calculDiff(WheelSide side) => roundDecimal(getWheel(side).diff, 2);

  Widget _buildTextfield(String hint, WheelSide side, bool isBack) {
    final wheel = getWheel(side);
    return TextFormField(
      initialValue: '${isBack ? wheel.backDistance : wheel.frontDistance}',
      decoration: InputDecoration(labelText: hint),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        _onFormEdit(
          value.trim().isNotEmpty ? double.parse(value.trim()) : 0.0,
          side,
          isBack,
        );
      },
    );
  }

  Widget _buildWheel(String title, WheelSide side) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final angle = _calculWheelAngle(side);
    return Expanded(
      child: CustomCard(
        children: [
          Text(title, style: titleStyle),
          const SizedBox(height: 16.0),
          Text('Diff: ${_calculDiff(side)}'),
          const SizedBox(height: 4.0),
          Text('Degrees: $angle°'),
          const SizedBox(height: 4.0),
          Text('Angle: ${degreeToMinute(angle)}'),
          const SizedBox(height: 16.0),
          _buildTextfield('Front distance', side, false),
          const SizedBox(height: 12.0),
          _buildTextfield('Back distance', side, true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ParaGuez'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: wheelSize.toString(),
              decoration: InputDecoration(labelText: 'Wheel size'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final wheelSize = double.parse(value);
                widget.prefs.setDouble('wheelSize', wheelSize);
                setState(() => this.wheelSize = wheelSize);
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              _buildWheel('Front left', WheelSide.FRONT_LEFT),
              _buildWheel('Front right', WheelSide.FRONT_RIGHT),
            ],
          ),
          Row(
            children: [
              _buildWheel('Rear left', WheelSide.REAR_LEFT),
              _buildWheel('Rear right', WheelSide.REAR_RIGHT),
            ],
          ),
        ],
      ),
    );
  }
}
