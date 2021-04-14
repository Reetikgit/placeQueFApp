import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_ui/util/animations.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/validations.dart';
import 'package:social_app_ui/views/screens/main_screen.dart';
import 'package:social_app_ui/views/widgets/custom_button.dart';
import 'package:social_app_ui/views/widgets/custom_text_field.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
// Firebase.initializeApp();

}

class _LoginState extends State<Login> {
  // FirebaseApp.initialzeApp(this);
  final dbRef = FirebaseDatabase.instance.reference().child("Users");
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController cpassController = TextEditingController();
  TextEditingController usnController = TextEditingController();
  TextEditingController LoginEmailController = TextEditingController();
  TextEditingController LoginPasswordController = TextEditingController();
  File _image;
  String profilePath;
  List<String> _sems = ['1st', '2nd', '3rd', '4th', '5th','6th','7th','8th'];
  List<String> _branch = ['ISE', 'CSE', 'MECH', 'CIVIL', 'ECE','EEE','MBA'];// Option 2
  String _selectedSems; // Option 2
  String _selectedBranch; // Option 2
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, pass, cpass, password, name = '';
  FocusNode nameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  FocusNode CpassFN = FocusNode();
  FocusNode usnFN = FocusNode();
  FocusNode LoginPassFN = FocusNode();
  FocusNode LoginEmailFN = FocusNode();
  FormMode formMode = FormMode.LOGIN;

  @override
  void initState() {
    getUSD();
    downloadImage();
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Select image path' + _image.path.toString());
    });
  }

  Future downloadImage() async {
    if (profilePath != null) {
      var image = new File(profilePath);
      setState(() {
        _image = image;
      });
    }
  }

  void getUSD() async {
    String USD = "";
    // SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Asas");
    setState(() {
      USD = prefs.getString('userToken');
    });
    print(USD);
    if (USD != "" && USD != null) {
      Navigate.pushPageReplacement(context, MainScreen());
    } else {}
  }

  login() async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
      // showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      Navigate.pushPageReplacement(context, MainScreen());
    }
  }

  setUSD(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs
        .setString('userToken', token)
        .then((value) => Navigate.pushPageReplacement(context, MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Row(
          children: [
            buildLottieContainer(),
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                child: Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: buildFormContainer(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildLottieContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      width: screenWidth < 700 ? 0 : screenWidth * 0.5,
      duration: Duration(milliseconds: 500),
      color: Theme.of(context).accentColor.withOpacity(0.3),
      child: Center(
        child: Lottie.asset(
          AppAnimations.chatAnimation,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  buildFormContainer() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Positioned(
            top: 125.0,
            left: 15.0,
            right: 15.0,
            child: Material(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20.0)),
              ),
            ),
          ),
          Positioned(
            top: 40.0,
            left: (MediaQuery.of(context).size.width / 2 - 70.0),
            child: Container(
              child: new Column(
                children: [
                  Visibility(
                      visible: formMode == FormMode.REGISTER,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: new Stack(fit: StackFit.loose, children: [
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Center(
                                child: _image == null
                                    ? new Icon(
                                        Icons.account_circle_outlined,
                                        color: Colors.grey,
                                        size: 140,
                                      )
                                    : new CircleAvatar(
                                        backgroundImage: new FileImage(_image),
                                        radius: 65.0,
                                      ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, left: 90.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new FloatingActionButton(
                                    foregroundColor: Colors.grey,
                                    backgroundColor: Colors.white,
                                    onPressed: getImage,
                                    tooltip: 'Pick Image',
                                    child: Icon(Icons.add_a_photo),
                                  ),
                                ],
                              )),
                        ]),
                      )),
                ],
              ),
            ),
          ),

          Visibility(
            visible: formMode != FormMode.REGISTER,
            child: new Image.asset(
              'assets/images/splash.png',
              width: 400.0,
              height: 140.0,
              fit: BoxFit.contain,
            ),
          ),

          // Text(
          //   '${Constants.appName}',
          //   style: TextStyle(
          //     fontSize: 40.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ).fadeInList(0, false),
          SizedBox(height: 30.0),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: buildForm(),
          ),
          Visibility(
            visible: formMode == FormMode.LOGIN,
            child: Column(
              children: [
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      formMode = FormMode.FORGOT_PASSWORD;
                      setState(() {});
                    },
                    child: Text('Forgot Password?'),
                  ),
                ),
              ],
            ),
          ).fadeInList(3, false),
          SizedBox(height: 20.0),

          Visibility(
            visible: formMode == FormMode.LOGIN,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                FlatButton(
                  onPressed: () {
                    formMode = FormMode.REGISTER;
                    setState(() {});
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ).fadeInList(5, false),
          Visibility(
            visible: formMode != FormMode.LOGIN,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                FlatButton(
                  onPressed: () {
                    formMode = FormMode.LOGIN;
                    setState(() {});
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: "Name",
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateName,
                controller: nameController,
                onSaved: (String val) {
                  name = val;
                },
                focusNode: nameFN,
                nextFocusNode: emailFN,
              ).fadeInList(1, true),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        Visibility(
          visible: formMode == FormMode.LOGIN,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: "Email",
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateName,
                controller: LoginEmailController,
                onSaved: (String val) {
                  email = val;
                },
                focusNode: LoginEmailFN,
                nextFocusNode: LoginPassFN,
              ).fadeInList(1, true),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: CustomTextField(
            enabled: !loading,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validateEmail,
            onSaved: (String val) {
              email = val;
            },
            controller: emailController,
            focusNode: emailFN,
            nextFocusNode: passFN,
          ).fadeInList(1, true),
        ),
        Visibility(
          visible: formMode != FormMode.FORGOT_PASSWORD &&
              formMode != FormMode.REGISTER,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: "Password",
                textInputAction: TextInputAction.done,
                validateFunction: Validations.validatePassword,
                controller: LoginPasswordController,
                submitAction: login,
                obscureText: true,
                onSaved: (String val) {
                  password = val;
                },
                focusNode: LoginPassFN,
              ).fadeInList(1, true),
              SizedBox(height: 20.0),
              buildButtonLogin(),
            ],
          ),
        ).fadeInList(1, true),
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              CustomTextField(
                enabled: !loading,
                hintText: "USN",
                textInputAction: TextInputAction.done,
                validateFunction: Validations.validateUsn,
                controller: usnController,
                // submitAction: login,
                obscureText: false,
                onSaved: (String val) {},
                focusNode: usnFN,
                nextFocusNode: passFN,
              ).fadeInList(1, true),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(10),

                    child: DropdownButton(

                        hint: Text('Semester'),
                        // Not necessary for Option 1
                        value: _selectedSems,
                        iconSize: 20,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSems = newValue;
                          });
                        },
                        items: _sems.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList()),
                  )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(10),
                    child: DropdownButton(
                        hint: Text('Branch'),
                        // Not necessary for Option 1
                        value: _selectedBranch,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBranch = newValue;
                          });
                        },
                        items: _branch.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList()),
                  ))
                ],
              ),
              CustomTextField(
                enabled: !loading,
                hintText: "Password",
                textInputAction: TextInputAction.done,
                validateFunction: Validations.validatePassword,
                controller: passController,
                // submitAction: login,
                obscureText: true,
                onSaved: (String val) {
                  pass = val;
                },
                focusNode: passFN,
                nextFocusNode: CpassFN,
              ).fadeInList(1, true),
              SizedBox(height: 20.0),
              CustomTextField(
                enabled: !loading,
                hintText: "Confirm Password",
                textInputAction: TextInputAction.done,
                validateFunction: Validations.validatePassword,
                // submitAction: login,
                controller: cpassController,
                obscureText: true,
                onSaved: (String val) {
                  cpass = val;
                },
                focusNode: CpassFN,
              ).fadeInList(1, true),
              SizedBox(height: 20.0),
              buildButtonSignup(),
            ],
          ),
        ).fadeInList(1, true),
      ],
    );
  }

  buildButtonLogin() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
                label: "Login",
                onPressed: () {
                  //=> login(),
                })
            .fadeInList(2, false);
  }

  buildButtonSignup() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            label: "Signup",
            onPressed: () {
              if(_selectedBranch!=null){
                if(_selectedSems!=null){
                  if (passController.text != "") {
                    if (cpassController.text == passController.text) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Please Wait ! Creating Your Account"),
                        backgroundColor: Colors.orange,
                      ));

                      writeData(nameController.text, emailController.text,
                          passController.text);
                    } else {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Password do not match"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  } else {}
                }else{
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Select your Semester"),
                    backgroundColor: Colors.red,
                  ));
                }
              }else{
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Select your Branch"),
                  backgroundColor: Colors.red,
                ));
              }



              //=> login(),
            }).fadeInList(2, false);
  }

  void writeData(name, email, pass) {

    var newRef = dbRef.push();
    var dataObj = {
      'id': usnController.text,
      'refId': newRef.key,
      'Name': nameController.text,
      'password': passController.text,
      'email': emailController.text,
      'branch':_selectedBranch,
      'sem':_selectedSems
    };

    newRef.set(dataObj).then((value) => setUSD(newRef.key));
  }
}
