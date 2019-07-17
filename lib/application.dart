import 'package:flutter/material.dart';

typedef void LocaleChangeCallback(Locale locale);

/// Dart中实现单例模式的标准做法就是使用static变量+工厂构造函数的方式，
/// 这样就可以保证new EventBus()始终返回都是同一个实例，读者应该理解并掌握这种方法。
class MyApplication {
  /// 支持的语言列表
  final List<String> supportedLanguages = ['zh','en'];

  ///将支持的语言列表[supportedLanguages]转为Locale列表
  Iterable<Locale> supportedLocales() => supportedLanguages.map<Locale>((lang) => Locale(lang, ''));

  /// 在更改系统语言时的回调函数
  LocaleChangeCallback onLocaleChanged;

  /// 保存单例
  static final MyApplication _myApplication = MyApplication._internal();

  /// 工厂构造函数
  factory MyApplication() {
    return _myApplication;
  }

  /// 私有构造函数
  MyApplication._internal();
}

/// 自我初始化的类。每次将其导入时，将返回该类的同一实例
final MyApplication myApplication = MyApplication();
