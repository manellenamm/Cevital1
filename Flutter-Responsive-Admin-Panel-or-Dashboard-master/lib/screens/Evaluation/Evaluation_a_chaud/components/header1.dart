import 'package:flutter/material.dart';
import 'package:admin/constants.dart';

class Header2 extends StatefulWidget {
  const Header2({
    Key? key,
  }) : super(key: key);

  @override
  _Header1State createState() => _Header1State();
}

class _Header1State extends State<Header2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 500, 
            child: 
          
            Text(
              "Evaluation à chaud de la formation",
              style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 20,
              ),
                           
              softWrap: true,
            ),
          ),
          SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
