import 'package:flutter/material.dart';

Color mainColor = Color(0xff831608);
//Color mainColor = Color(0xff77198c); // primary buttons 831608
Color mainTextColor = Color(0xff2e384d);

Color textFieldBorderColor = Color(0xffb0018a);


Map<int, Color> cColor = {
  50: Color.fromRGBO(131, 22, 8, .1),
  100: Color.fromRGBO(131, 22, 8, .2),
  200: Color.fromRGBO(131, 22, 8, .3),
  300: Color.fromRGBO(131, 22, 8, .4),
  400: Color.fromRGBO(131, 22, 8, .5),
  500: Color.fromRGBO(131, 22, 8, .6),
  600: Color.fromRGBO(131, 22, 8, .7),
  700: Color.fromRGBO(131, 22, 8, .8),
  800: Color.fromRGBO(131, 22, 8, .9),
  900: Color.fromRGBO(131, 22, 8, 1),
};

MaterialColor materialMainColor = MaterialColor(0xff831608, cColor);