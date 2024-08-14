import 'package:flutter/material.dart';
import 'package:admin/constants.dart';

class Header3 extends StatefulWidget {
  const Header3({
    Key? key,
  }) : super(key: key);

  @override
  _Header3State createState() => _Header3State();
}

class _Header3State extends State<Header3> {
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
              "Evaluation (personnes non cadrés)",
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
