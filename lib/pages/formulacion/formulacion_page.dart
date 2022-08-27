import 'package:cliente/pages/formulacion/pages/inorganica/inorganica_page.dart';
import 'package:cliente/widgets/margined_column.dart';
import 'package:flutter/material.dart';

import '../../widgets/gradient_box_decoration.dart';
import '../../widgets/home_app_bar.dart';
import '../../widgets/margined_row.dart';
import '../constants.dart' as constants;
import '../constants.dart';

class FormulacionPage extends StatelessWidget {
  const FormulacionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              HomeAppBar(
                title: Image.asset(
                  'assets/images/icons/branding_slim.png',
                  height: 17,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: constants.bodyBoxDecoration,
                  // To avoid rounded corners overflow:
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: MarginedColumn.top(
                      top: 30,
                      child: Column(
                        children: [
                          MarginedRow(
                            margin: 25,
                            child: Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    'Inorgánica',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.help_outline),
                                    // To remove padding:
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(width: 25),
                                MenuCard(
                                  title: 'Formular o nombrar',
                                  structure: 'H₂O',
                                  name: 'dióxido de hidrógeno',
                                ),
                                MenuCard.locked(title: 'Practicar'),
                                SizedBox(width: 5),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          MarginedRow(
                            margin: 25,
                            child: Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    'Orgánica',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.help_outline),
                                    // To remove padding:
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(width: 25),
                                MenuCard(
                                  title: 'Formular',
                                  structure: 'No sé qué poner',
                                  name: 'Aquí tampoco',
                                ),
                                MenuCard(
                                  title: 'Nombrar simple',
                                  structure: 'CH₃ - COOH',
                                  name: 'ácido etanoico',
                                ),
                                MenuCard(
                                  title: 'Nombrar éter',
                                  structure: 'CH₃ - O - CH₂CH₃',
                                  name: 'etil metil éter',
                                ),
                                MenuCard.locked(
                                  title: 'Nombrar éster',
                                ),
                                MenuCard.locked(
                                    title: 'Nombrar cíclico'
                                ),
                                MenuCard.locked(
                                    title: 'Nombrar aromático'
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          ),
                          SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard(
      {Key? key,
      required this.title,
      this.customBody,
      required this.structure,
      required this.name})
      : super(key: key);

  const MenuCard.locked(
      {Key? key,
      required this.title,
      this.customBody,
      this.structure,
      this.name})
      : super(key: key);

  const MenuCard.custom(
      {Key? key,
      required this.title,
      required this.customBody,
      this.structure,
      this.name})
      : super(key: key);

  final String title;

  final Widget? customBody;

  final String? structure;
  final String? name;

  static MarginedColumn lockedBody = MarginedColumn.top(
    top: 15,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Icon(
            Icons.lock,
            size: 35,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 7),
        Center(
          child: Text(
            'Próximamente',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (structure == null)
      body = customBody ?? lockedBody;
    else
      body = MarginedRow(
        margin: 25,
        child: MarginedColumn.top(
          top: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                structure!,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: quimifyTeal,
                ),
              ),
              SizedBox(height: 15),
              Text(
                name!,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );

    return Row(
      children: [
        InkWell(
          child: Container(
            width: 270,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            // To avoid rounded corners overflow:
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: gradientBoxDecoration,
                  child: MarginedRow(
                    margin: 25,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                body,
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const InorganicaPage();
                },
              ),
            );
          },
        ),
        SizedBox(width: 15),
      ],
    );
  }
}
