import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/Verify.dart';
import 'package:flutter_firebase/utils/utils.dart';

class PhoneNumberAuthentication extends StatefulWidget {
  const PhoneNumberAuthentication({Key? key}) : super(key: key);

  @override
  State<PhoneNumberAuthentication> createState() =>
      _PhoneNumberAuthenticationState();
}

class _PhoneNumberAuthenticationState extends State<PhoneNumberAuthentication>
{

  bool loading = false;

  TextEditingController PhoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Number Authentication"),
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
                  controller: PhoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
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
                      return 'Enter valid phone number';
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
                onPressed: () {
                  if (_formKey.currentState!.validate())
                  {
                    setState(() {
                      loading = true;
                    });
                    _auth.verifyPhoneNumber(
                      phoneNumber: "+91"+PhoneNumberController.text.toString(),
                        verificationCompleted: (_){

                        },
                        verificationFailed: (error){
                        setState(() {
                          loading=false;
                        });
                        Utils().showToast(error.toString());
                        },
                        codeSent:(String VerificationId, int ? code)
                        {
                          setState(() {
                            loading=false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CodeVerification(VerificationId: VerificationId)));
                        },
                        codeAutoRetrievalTimeout:(error)
                        {
                          setState(() {
                            loading=false;
                          });
                          Utils().showToast(error.toString());
                        }
                    );
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
