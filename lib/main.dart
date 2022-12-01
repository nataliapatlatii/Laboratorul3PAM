import 'package:calculator/cal_button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  /*
   * Variabilă pentru textul butoanelor
   */
  final List<String> buttonsList = [
    'C',
    '',
    '\u00ac',
    '\u00f7',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '',
    '0',
    '.',
    '=',
  ];

  /*
   * Variabilă pentru selectarea butoanelor de comutare
   */
  final isSelected = <bool>[false, false];

  final modeColors = <Color>[Colors.black, Colors.grey];
  final scaffoldColors = <Color>[Color(0xffFFFFFF), Color(0xff22252D)];
  final toggleColors = <Color>[Color(0xffF9F9F9), Color(0xff2A2D37)];
  final buttonsColor = <Color>[Color(0xffFFFFF), Color(0xffFFFFFF)];
  final numberColors = <Color>[Colors.grey, Colors.white];
  final signColors = <Color>[Color(0xffF2797B), Color(0xff62E5CE)];
final newcolor = Colors.blue;
  final textWeights = <FontWeight>[
    FontWeight.normal,
    FontWeight.bold,
    FontWeight.bold
  ];

  final textSizes = <double>[25, 30, 25];
  final textColors = <Color>[Colors.black, Colors.white, Color(0xffF2797B)];

  int textColorsIndex = 0;
  int textStyleIndex = 0;
  int whichModeSelected = 0;

  String inputPhrase = "0";

  /*
   * Variabile pentru intrările din magazin.
   */
  String input1 = "";
  String input2 = "";
  String opr = "";

  /*
   * Această funcție gestionează intrările utilizatorului.
   * 
   * @param char este caracterul introdus de la utilizator.
   */
  void updateInputPhrase(String char) {
    if (isDigit(char)) {
      setState(() {
        textStyleIndex = 0;
        textColorsIndex = whichModeSelected;
      });
      if (inputPhrase != "") {
        if (inputPhrase[0] == "0") {
          if (inputPhrase.length > 1) {
            if (inputPhrase[1] == ".") {
              setState(() {
                inputPhrase += char;
              });
            }
          } else {
            setState(() {
              inputPhrase = char;
            });
          }
        } else if (isOperator(inputPhrase[0])) {
          opr = inputPhrase[0];
          inputPhrase = char;
        } else {
          setState(() {
            inputPhrase += char;
          });
        }
      } else {
        setState(() {
          inputPhrase += char;
        });
      }
    }

    // Clear entry
    if (char == '\u00ac') {
      if (inputPhrase.length == 1) {
        setState(() {
          inputPhrase = "0";
        });
      } else {
        setState(() {
          inputPhrase = inputPhrase.substring(0, inputPhrase.length - 1);
        });
      }
    }

    // All clear
    if (char == "C") {
      setState(() {
        textColorsIndex = whichModeSelected;
        textStyleIndex = 0;
        inputPhrase = "0";
        input1 = "";
        input2 = "";
        opr = "";
      });
    }

    if (char == "%") {
      input1 = inputPhrase;
      opr = "/";
      inputPhrase = "100";
      if (input1 != "0")
        calculate();
      else
        inputPhrase = "0";
    }

    if (isOperator(char)) {
      if (!isOperator(inputPhrase)) {
        input1 = inputPhrase;
        setState(() {
          textColorsIndex = 2;
          textStyleIndex = 2;
          inputPhrase = char;
        });
      } else {
        setState(() {
          inputPhrase = char;
        });
      }
    }

    if (char == "=") {
      calculate();
    }

    if (char == "." && !inputPhrase.contains(".")) {
      setState(() {
        inputPhrase += char;
      });
    }
  }

  /*
   * Această funcție calculează fraza de intrare
   */
  void calculate() {
    input2 = inputPhrase;

    String finalPhrase = input1 + opr + input2;
    print("num1 : " + input1);
    print("Operator : " + opr);
    print("num2 : " + input2);
    print(finalPhrase);
    finalPhrase = finalPhrase.replaceAll('x', '*');
    finalPhrase = finalPhrase.replaceAll('÷', '/');

    Parser parser = Parser();
    Expression expression = parser.parse(finalPhrase);
    ContextModel contextModel = ContextModel();
    double answer = expression.evaluate(EvaluationType.REAL, contextModel);
    setState(() {
      inputPhrase = answer.toString();
      textColorsIndex = whichModeSelected;
      textStyleIndex = 1;
    });
  }

  /*
   * Această funcție verifică dacă caracterul introdus este un operator sau nu.
   * 
   * @param char este caracterul pentru a verifica dacă este un operator.
   */
  bool isOperator(String char) {
    if (char == "\u00f7" || char == "x" || char == "-" || char == "+")
      return true;
    else
      return false;
  }

  /*
   * Această funcție verifică dacă caracterul introdus este un număr sau nu.
   * 
   * @param char este caracterul pentru a verifica dacă este n număr.
   */
  bool isDigit(String char) {
    if (char != "C" &&
        char != "%" &&
        char != '\u00ac' &&

        char != "." &&
        char != "=" &&
        !isOperator(char))
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColors[whichModeSelected],
      body: Container(
        child: Column(
          children: [
            // Toggle Buttons View
            Center(
              child: Container(
                margin: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: toggleColors[whichModeSelected],
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            // Input Box
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      inputPhrase,
                      style: TextStyle(
                          color: textColors[textColorsIndex],
                          fontSize: textSizes[textStyleIndex],
                          fontWeight: textWeights[textStyleIndex],
                          fontFamily: 'VarelaRound'),
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 10, right: 20, bottom: 40, left: 20),
            ),
            // Calculator
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: toggleColors[whichModeSelected],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  children: List.generate(buttonsList.length, (index) {
                    // C
                    if (index == 0) {
                      return CalButton(
                          textColor: signColors[0],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }

                    // RETURN
                    if (index == 2) {
                      return CalButton(
                          textColor: signColors[1],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // Division
                    if (index == 3) {
                      return CalButton(
                          textColor: signColors[1],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // X
                    if (index == 7) {
                      return CalButton(
                          textColor: signColors[1],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // -
                    if (index == 11) {
                      return CalButton(
                          textColor: signColors[1],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // +
                    if (index == 15) {
                      return CalButton(
                          textColor: signColors[1],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // =

                    if (index == 19) {
                      return CalButton(
                          textColor: signColors[1],
                           color:newcolor,
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    } else {
                      return CalButton(
                          textColor: numberColors[whichModeSelected],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
