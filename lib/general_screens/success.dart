import 'package:devotionals/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Center(
            child: Icon(
              MdiIcons.checkCircle,

              size: MediaQuery.of(context).size.width*0.5,
              color: cricColor,
            ),
          ),

          SizedBox(height: 40,),

          Text(
            'Successful',
            
            style: TextStyle(
              fontSize: 20
            ),
          ),

          SizedBox(height: 100,),

          TextButton.icon(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: Icon(
              MdiIcons.close
            ), 
            label: Text(
              'Close'
            ))
        ],
      ),
    );
  }
}