import 'package:devotionals/firebase/dbs/prayerrequest.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/utils/models/user.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:devotionals/utils/models/prayerreq.dart';

import '../../../../dbs/sembast/userdb.dart';

class AddPrayerRequestScreen extends StatefulWidget {
  final String uid;
  const AddPrayerRequestScreen(
    this.uid,
    {Key? key}) : super(key: key);

  @override
  _AddPrayerRequestScreenState createState() => _AddPrayerRequestScreenState();
}

class _AddPrayerRequestScreenState extends State<AddPrayerRequestScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _requestController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Prayer Request'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LoadingIndicator(
            loading: _loading,
            child: Column(
              children: [
                SingleLineField(
                  '',
                  headerText: 'Subject',
                  controller: _titleController,
                  suffixIcon: MdiIcons.calendar,

                  onChanged: (){setState(() {
                    
                  });},
                  
                ),
                SizedBox(height: 20),

                SingleLineField(
                  'Add your prayer request',
                  headerText: 'Request',
                  controller: _requestController,
                  minLines: 10,
                  maxLines: 10,

                  onChanged: (){setState(() {
                    
                  });},
                ),
               
                SizedBox(height: 40),
                DefaultButton(
                  active: _requestController.text.trim().isNotEmpty && _titleController.text.trim().isNotEmpty,
                  onTap: () async {
                    setState(() {
                      _loading = true;
                    });

                    User? _user;

                    if (await UserRepo().containsKey(widget.uid)) {
                      _user = await UserRepo().get(widget.uid);
                      print('yes');
                    } else {
                      _user = await UserService().getUser(widget.uid);
                      await UserRepo().insert(_user!);
                    }
                   
                    final prayerRequest = PrayerRequest(
                      id: DateTime.now().millisecondsSinceEpoch.toString(), // Assign a unique ID
                      user: _user!,
                      date: DateTime.now(),
                      title: _titleController.text,
                      request: _requestController.text,
                    );
            
                    // Add the prayer request to Firestore
                    await PrayerFire().addPrayerRequest(prayerRequest);
            
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Your prayer request has been submitted.'),
                        backgroundColor: Colors.green,
                      ),
                    );
            
                    setState(() {
                      _loading = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _requestController.dispose();
    super.dispose();
  }
}
