import 'package:flutter/material.dart';

class RecipeStepContainer extends StatelessWidget {
  const RecipeStepContainer(
      {required this.index,
      required this.step,
      this.actions = const <Widget>[],
      super.key});
  final int index;
  final String step;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 48, 47, 47),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange, width: 1),
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 162, 255),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Text(
                    step,
                    softWrap: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1 + actions.length,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: actions
                  )
                )
              ],
            ),
          )),
    );
  }
}
