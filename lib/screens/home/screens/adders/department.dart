
import 'package:devotionals/firebase/dbs/department.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/department.dart';
import 'package:devotionals/utils/models/user.dart';
import 'package:devotionals/utils/widgets/allusers.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

class AddDepartment extends StatefulWidget {
  const AddDepartment({super.key});

  @override
  State<AddDepartment> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {

  final titleController = TextEditingController();
  final hodController = TextEditingController();

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
        title: Text('Add Department'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LoadingIndicator(
            loading: _loading,
            child: Column(
              children: [
            
              SingleLineField('',
                headerText: 'Name of Department',
                controller: titleController,
                  
                suffixIcon: MdiIcons.calendar,
                 
                onChanged: (){
                  setState(() {
                    
                  });
                },
                  
              ),
            
            
              SizedBox(height: 20,),

              SingleLineField('Select',
                headerText: 'Head of Department',
                controller: hodController,
                  
                suffixIcon: MdiIcons.accountOutline,
                makeButton: true,


                onTap: ()async{
                  var user = await Navigator.push(
                    context,
                    PageTransition(child: UserListScreen(), type: PageTransitionType.bottomToTop)
                  );

                  if (user != null) {
                     hodController.text = user.firstName +' '+ user.lastName;
                     hod = user;
                  }
                },
                 
                onChanged: (){
                  setState(() {
                    
                  });
                },
                  
              ),
            
              SizedBox(height: 40,),
            
            
                DefaultButton(
                  active: titleController.text.trim().length>=5,

                  onTap: ()async{

                    setState(() {
                      _loading = true;
                    });


                    DepartmentFire departmentFire = DepartmentFire();
                    await departmentFire.addDepartment(
                      DepartmentModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(), 
                        name: titleController.text,
                        hod: hod,
                        members: []
                      )
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Department added successfully', style: TextStyle(color: cricColor),),
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