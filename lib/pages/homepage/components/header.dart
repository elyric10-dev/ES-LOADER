import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';

class header extends StatelessWidget {
  const header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "ES-Loader",
              style: TextStyle(
                fontSize: 35,
                color: Colors.amber,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Spacer(),
          BlinkText(
            'Buy Load Here',
            style: TextStyle(fontSize: 45.0, color: Colors.redAccent),
            beginColor: Colors.redAccent,
            endColor: Color.fromARGB(255, 38, 50, 56),
            times: 3000000,
            duration: Duration(milliseconds: 500),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
