
import 'package:devotionals/firebase/dbs/cell.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/cell.dart';
import 'package:devotionals/utils/models/user.dart';
import 'package:devotionals/utils/widgets/allusers.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

class AddCell extends StatefulWidget {
  const AddCell({super.key});

  @override
  State<AddCell> createState() => _AddCellState();
}

class _AddCellState extends State<AddCell> {

  final titleController = TextEditingController();
  final leaderController = TextEditingController();
  final locationController = TextEditingController();

  User? hod;



  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Cell'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LoadingIndicator(
            loading: _loading,
            child: Column(
              children: [
            
              SingleLineField('',
                headerText: 'Name of Cell',
                controller: titleController,
                  
                suffixIcon: MdiIcons.calendar,
                 
                onChanged: (){
                  setState(() {
                    
                  });
                },
                  
              ),
            
            
              SizedBox(height: 20,),

              SingleLineField('Select',
                headerText: 'Cell Leader',
                controller: leaderController,
                  
                suffixIcon: MdiIcons.accountOutline,
                makeButton: true,


                onTap: ()async{
                  var user = await Navigator.push(
                    context,
                    PageTransition(child: UserListScreen(), type: PageTransitionType.bottomToTop)
                  );

                  if (user != null) {
                     leaderController.text = user.firstName +' '+ user.lastName;
                     hod = user;
                  }
                },
                 
                onChanged: (){
                  setState(() {
                    
                  });
                },
                  
              ),
            
              SizedBox(height: 20,),

              SingleLineField('',
                headerText: 'Location',
                controller: locationController,
                  
                suffixIcon: MdiIcons.calendar,
                 
                onChanged: (){
                  setState(() {
                    
                  });
                },
                  
              ),
            
            
              SizedBox(height: 60,),
            
            
                DefaultButton(
                  active: titleController.text.trim().length>=5 && locationController.text.isNotEmpty,

                  onTap: ()async{

                    setState(() {
                      _loading = true;
                    });


                    CellFire cellFire = CellFire();
                    await cellFire.addCell(
                      CellModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(), 
                        name: titleController.text,
                        location: locationController.text,
                        leader: hod,
                        members: []
                      )
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cell added successfully', style: TextStyle(color: cricColor),),
                        backgroundColor: Colors.white,
                      )
                    );



                    setState(() {
                      _loading = false;
                    });
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}