import 'package:flutter/material.dart';

import 'package:cliente/widgets/home_app_bar.dart';
import 'package:cliente/widgets/constants.dart';

import '../../tools/text.dart';

class CalculadoraPage extends StatelessWidget {
  const CalculadoraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            HomeAppBar(
              title: Text(
                'Calculadora',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                decoration: bodyBoxDecoration,
                width: double.infinity,
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                // Vertically scrollable for short devices:
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 30, left: 25, right: 25),
                  child: Column(
                    children: [
                      Input(),
                      SizedBox(height: 20),
                      Output(),
                      SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: quimifyGradient,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Calcular',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 30),
                      Graph(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const TextStyle subTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

const TextStyle inputOutputStyle = TextStyle(
  color: quimifyTeal,
  fontSize: 26,
  fontWeight: FontWeight.bold,
);

class Input extends StatefulWidget {
  Input({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(20),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fórmula',
            style: subTitleStyle,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: TextField(
              // Aspect:
              cursorColor: Color.fromARGB(255, 34, 34, 34),
              style: inputOutputStyle,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 10),
                isCollapsed: true,
                //filled: false,
                labelText: 'H₂SO₄',
                labelStyle: inputOutputStyle,
                // So hint doesn't go up while typing:
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: quimifyTeal.withOpacity(0.5)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: quimifyTeal.withOpacity(0.5)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: quimifyTeal),
                ),
              ),
              // Logic:
              textInputAction: TextInputAction.done,
              controller: widget._controller,
              onChanged: (String input) {
                widget._controller.value = widget._controller.value.copyWith(
                  text: toSubscripts(toCapsAfterDigit(toFirstCap(input))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Output extends StatefulWidget {
  const Output({Key? key}) : super(key: key);

  @override
  State<Output> createState() => _OutputState();
}

class _OutputState extends State<Output> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(20),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masa molecular',
            style: subTitleStyle,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(
              '98 g/mol',
              style: inputOutputStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: quimifyTeal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'H₂SO₄',
                style: TextStyle(
                  color: quimifyTeal,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Switch(
                activeColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: true,
                  onChanged: (bool) {}),
            ],
          )
        ],
      ),
    );
  }
}
