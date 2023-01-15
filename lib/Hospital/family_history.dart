import 'package:flutter/material.dart';
import '../common/apis.dart';

class FamilyHistory extends StatefulWidget {
  @override
  _FamilyHistoryState createState() => _FamilyHistoryState();
}

class _FamilyHistoryState extends State<FamilyHistory> {
       List<dynamic> familyhistory = [];
  List<dynamic> originalFamilyhistory = [];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
        var data = {
         "treatmentPlan_id" : Apis.id
      };
      dynamic response = await Apis.showsession(data);
      this.originalFamilyhistory = response;
      setState(() {
        this.familyhistory = response;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: Scaffold(
      appBar:  AppBar(
         title: Text( 
            "Family history",
            style: TextStyle(
              color: Colors.white
            ),),
        backgroundColor: Colors.pinkAccent,
          leading: FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Icon(  
            Icons.arrow_back,
            color: Colors.white
          ), ), ),
          
      body:ListView(
children: <Widget>[
        ...familyhistory.map<Widget>((item) {
                return _listItem(
                  item,
                );
              }).toList(),
],
    ),
    ),
    );
          
      
  }
  _listItem(dynamic familyhistoryItem){
    return       Container(
          margin: EdgeInsets.only(left:20,right:20,top: 30),
          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
          width: 320,
          height: 150,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.pinkAccent.withOpacity(.2), width: 1),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 30,
                    spreadRadius: 5)
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Center(child:
                          Text(
                            
                        '                           Family History 1',
                        style: TextStyle(
              color:Color(0xFF00B6F0)
            ),
                      ),
                      
                          ),
                          Divider(
                        color: Colors.black38,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                        ]
                      ),
                       Text(
                        'Zeinab',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      
                      Text(
                        'Father',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                       Divider(
                        color: Colors.black38,
                      ),
                      SizedBox(
                        height: 1,
                      ),  Text(
                        'Condition',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                     
                      Text(
                        'Cancer free',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                       Divider(
                        color: Colors.black38,
                      ),
                      SizedBox(
                        height: 1,
                      ),
                       
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
  }
}
  