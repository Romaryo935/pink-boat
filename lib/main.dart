import 'package:flutter/material.dart';
import 'package:flutterapp/Routing.dart';
import 'package:flutterapp/common/config.dart';
import 'package:intl/date_symbol_data_local.dart';
import './Containers/signin.dart';
import './Widgets/sharedpref.dart';
import 'dart:io';
dynamic chk;
dynamic chk1;
dynamic fingerchk;
 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await initializeDateFormatting() ;
  await checkshared();
   await check2ndflag();
await check3rdflag();
  runApp(App());

 
}
bool nnnn=false;

class App extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
 //sleep(const Duration(seconds: 2));
   //  .then((_){  
        if(chk==true){
         if(chk1==true) 
              nnnn=true;
           
     }
     else{ nnnn=false;
     }
    // });
    // TODO: implement build
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      title: AppTitle,
      home: mainrr(context),
      
    );
  }
}

