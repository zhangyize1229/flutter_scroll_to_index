
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier , DiagnosticableTreeMixin{

  int _currentIndex=0;

  int get currentIndex => _currentIndex;

  void onChange(index){
    _currentIndex=index;
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('currentIndex',_currentIndex));
  }
}