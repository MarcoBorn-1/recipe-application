import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_container.dart';
import 'package:frontend/common/widgets/title_text.dart';

class SelectNutrientsWidget extends StatefulWidget {
  const SelectNutrientsWidget(
      this.title, this.valueMin, this.valueAvg, this.valueMax, this.unit,
      {super.key});
  final String title;
  final int valueMin;
  final int valueAvg;
  final int valueMax;
  final String unit;

  @override
  State<StatefulWidget> createState() => _SelectNutrientsWidgetState();
}

class _SelectNutrientsWidgetState extends State<SelectNutrientsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TitleText(widget.title),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomContainer(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.valueMin.toString() +
                          " - " +
                          widget.valueAvg.toString() + " " + widget.unit,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomContainer(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.valueAvg.toString() +
                          " - " +
                          widget.valueMax.toString() + " " + widget.unit,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomContainer(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "> " + widget.valueMax.toString() + " " + widget.unit,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
