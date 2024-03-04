import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {


  final emailController = TextEditingController();
  bool loading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: LoadingIndicator(
            loading: loading,
            child: Column(
              children: [
                const SizedBox(height: 10,),
          
                Row(
                  children: [
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
          
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width-30,
                      child: const Text(
                        'Provide Your registered Email to get a\nreset link',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(
                  height: 50,
                ),
          
          
                SingleLineField(
                  'Email',
                  controller: emailController,
          
                  onChanged: () {
                    setState(() {
                      
                    });
                  },
                ),
          
                const SizedBox(
                  height: 30,
                ),
          
          
                const SizedBox(
                  height:50
                ),
          
                DefaultButton(
                  text: 'Submit',
                  active: RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9_a-zA-Z0-9!_+=-~*£]+@[a-zA-Z0-9.a-zA-Z0-9_a-zA-Z0-9-a-zA-Z0-9]+\.[a-zA-Z0-9]+').hasMatch(emailController.text),
                  onTap: ()async{
                    setState(() {
                      loading = true;
                    });

                    final _auth = AuthService();

                    await _auth.sendPasswordResetEmail(emailController.text);

                    setState(() {
                      loading = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Recovery email sent to ${emailController.text}')
                      )
                    );
                    Navigator.pop(context);
                },
          
                ),
          
              ],
            ),
          ),
        ),
      ),


    );
  }
}