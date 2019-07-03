import 'package:flutter/material.dart';

class MCScreen {

  double width;
  double height;

  static Size _size;
  static double _widthScale;
  static double _heightScale;

  MCScreen({
    this.width = 0,
    this.height = 0,
  });

  /// 单例
  static MCScreen instance = new MCScreen();

  static MCScreen getInstance() {
    return instance;
  }

  /// 初始化
  void init(BuildContext context) {
    // 当前设备分辨率
    _size = MediaQuery.of(context).size;
    // 比例
    _widthScale = _size.width / this.width;
    _heightScale = _size.height / this.height;
  }

  /// 获取屏幕宽度
  static double get screenWidth => _size.width;
  /// 获取屏幕高度
  static double get screenHeight => _size.height;
  /// 根据设计图比例进行宽度适配
  setWidth(double width) => width * _widthScale;
  /// 根据设计图比例进行高度适配
  setHeight(double height) => height * _heightScale;
}