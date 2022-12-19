import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/post_screen.dart';
import 'package:flutter_firebase/utils/utils.dart';

class CodeVerification extends StatefulWidget {

  final String VerificationId;

  CodeVerification({Key? key, required this.VerificationId}) : super(key: key);

  @override
  State<CodeVerification> createState() =>
      _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification>
{

  bool loading = false;

  TextEditingController CodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Code Verification"),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(top: 70.0, bottom: 4.0, left: 20, right: 20),
                child: TextFormField(
                  controller: CodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Code",
                    prefixIcon: Icon(Icons.verified_user),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    RegExp regex =
                    RegExp(r'^(?=.*?[0-9])');
                    if (value == null || value.isEmpty)
                    {
                      return 'Please enter password';
                    } else if (!regex.hasMatch(value))
                    {
                      return 'Enter valid code';
                    }
                    else
                    {
                      return null;
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  fixedSize: Size(1000, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  if (_formKey.currentState!.validate())
                  {
                    final credentials = PhoneAuthProvider.credential(
                        verificationId: widget.VerificationId,
                        smsCode: CodeController.text.toString()
                    );

                    try{

                      await _auth.signInWithCredential(credentials);

                      setState(() {
                        loading = false;
                      });

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PostScreen()));
                    }
                    catch(e)
                  {
                    setState(() {
                      loading = false;
                    });
                    Utils().showToast(e.toString());
                  }
                  }
                },
                child: loading == true ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white,) : const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
