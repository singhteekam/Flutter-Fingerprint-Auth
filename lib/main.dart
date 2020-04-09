import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _localAuthentication= LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot= "Not Authorized";
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  Future<void> _checkBiometric()async{
    bool canCheckBiometric = false;
    try{
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    }on PlatformException catch(e){
      print(e);
    }
    if(!mounted) return;

    setState(() {
      _canCheckBiometric= canCheckBiometric;
    });
  }

   Future<void> _getListOfBiometricTypes()async{
    List<BiometricType> listOfBiometrics;
    try{
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    }on PlatformException catch(e){
      print(e);
    }
    if(!mounted) return;

    setState(() {
      _availableBiometricTypes= listOfBiometrics;
    });
  }

   Future<void> _authorizeNow()async{
    bool isAuthorized = false;
    try{
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to proceed",
        useErrorDialogs: true,
        stickyAuth: true,
        );
    }on PlatformException catch(e){
      print(e);
    }
    if(!mounted) return;

    setState(() {
      if(isAuthorized){
        _authorizedOrNot= "Authorized";
      }
      else{
        _authorizedOrNot= "Not Authorized";
      }
      
    });
  }

 @override 
 Widget build(BuildContext context){
   return Scaffold(
     appBar: new AppBar(
       title: Text("Fingerprint Auth"),
     ),
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Text("Can we check biometric: $_canCheckBiometric"),
            RaisedButton(
              onPressed: _checkBiometric,
              child: Text("Check Biometric"),
              color: Colors.blue,
              colorBrightness: Brightness.light,
            ),
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: Text("List of biometric types: ${_availableBiometricTypes.toString()}"),
            ),
            RaisedButton(
              onPressed: _getListOfBiometricTypes,
              child: Text("List of  Biometric Types"),
              color: Colors.blue,
              colorBrightness: Brightness.light,
            ),
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: Text("Authorized: $_authorizedOrNot"),
            ),
            RaisedButton(
              onPressed: _authorizeNow,
              child: Text("Authorized now"),
              color: Colors.blue,
              colorBrightness: Brightness.light,
            )
         ],
       ),
     ),
   );
 }
}
