import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectTimeWidget extends StatelessWidget {
  const SelectTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Time", 
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white, 
            fontSize: 32,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: const  [
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Icon(
                    CupertinoIcons.timer, 
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "< 15 mins", 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Column(),
            Column(),
          ],
          )
      ],
    );
  }
}
