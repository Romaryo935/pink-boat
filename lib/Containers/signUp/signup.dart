import 'package:flutter/material.dart';
import 'package:flutterapp/Containers/signUp/verify.dart';
import 'package:flutterapp/common/apis.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:js_shims/js_shims.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterapp/home.dart';
//import 'package:flutter_masked_text/flutter_masked_text.dart';
//import 'package:international_phone_input/international_phone_input.dart';
BuildContext co;
class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);
  @override
  _SignUp createState() => _SignUp();
}

class City {
  String citycode;
  String cityname;

  City(this.citycode, this.cityname);

  City.fromJson(Map<String, dynamic> json) {
    citycode = json['_id'];
    cityname = json['name'];
  }
}


class Area {
  String areacode;
  String areaname;

  Area(this.areacode, this.areaname);

  Area.fromJson(Map<String, dynamic> json) {
    areacode = json['_id'];
    areaname = json['name'];
  }
}



class _SignUp extends State<SignUp> {
  List<City> _cities = List<City>();
  List<City> _citiessearched = List<City>();

  List<Area> _areas = List<Area>();
  List<Area> _areassearched = List<Area>();



  Future<List<City>> fetchcities() async {
    var url = 'https://pinkboat.herokuapp.com/getallcities';
    var response = await http.get(url);
    var cities = List<City>();

    if (response.statusCode == 200) {
      var citiesJson = json.decode(response.body);
      for (var cityJson in citiesJson) {
        cities.add(City.fromJson(cityJson));
      }
    }
    return cities;
  }



  Future<List<Area>> fetchAreas(String city_Code) async {
    var url = 'https://pinkboat.herokuapp.com/getAllAreasOfCity';
    var data = {"city": city_Code};
    var response = await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
    var areas = List<Area>();

    if (response.statusCode == 200) {
      var areasJson = json.decode(response.body);
      for (var areaJson in areasJson) {
        areas.add(Area.fromJson(areaJson));
      }
      //static dynamic areas=areasJson["areas"] as List;
      return areas;

    }  
  }


  @override
  void initState() {
    super.initState();
    fetchcities().then((value) {
      _cities.addAll(value);
      setState(() {
        _citiessearched.addAll(value);
      });
    });
  }


  final _formKey = GlobalKey<FormState>();

  FocusNode _nidFocusNode = FocusNode();
  FocusNode _fnameFocusNode = FocusNode();
  FocusNode _mnameFocusNode = FocusNode();
  FocusNode _lnameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _repasswordFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _areaFocusNode = FocusNode();
  FocusNode _streetFocusNode = FocusNode();
  FocusNode _signUpFocusnode = FocusNode();

  Color labelgrey = Colors.black54;
  Color pink = Colors.pinkAccent;
  Color grey = Colors.black87;
  //Color cityDialogSearchIcon=Colors.black12;

  //String genderSelection;

  bool secured1 = true;
  bool secured2 = true;
  //DateTime startDate = DateTime.now();
  // DateTime endDate = DateTime.now().add(const Duration(days: 5));

  String _national_id;
  String _first_name;
  String _last_name;
  String _middle_name;
  String _email;
  String _password;
  String _re_password;
  //bool _gender;
  //String _bDate;
  String _phone;
  String _city;
  String _area;
  String _street;

  // handle_National_Id() {
  //   if (_national_id.length >= 12) {
  //     _gender = checkGender(_national_id[12]);
  //     _bDate = getBirthDate(_national_id);
  //     print(_gender);
  //   } else {
  //     print("wait..");
  //   }
  // }

  // bool checkGender(number) {
  //   if (int.parse(number) % 2 == 0) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // String getBirthDate(String nid) {
  //   var dob = substr(nid, 1, 6);
  //   var year = substr(dob, 0, 2);
  //   if (nid[0] == "2") {
  //     year = "19" + year;
  //   }
  //   if (nid[0] == "3") {
  //     year = "20" + year;
  //   }
  //   var month = int.parse(substr(dob, 2, 2));
  //   var day = int.parse(substr(dob, 4, 2));
  //   DateTime myBirthDate = new DateTime(int.parse(year), month, day);
  //   print(myBirthDate);
  //   //this._bDate = myBirthDate.toString();
  //   return myBirthDate.toString();
  // }

  Widget Nid_Input() {
    return TextFormField(
      focusNode: _nidFocusNode,
      autofocus: true,
      maxLength: 14,
      //onChanged:handle_National_Id(),
      style: TextStyle(color: this.grey),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.number,
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly
      ], // ??????only allow input of numbers
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: this.pink, width: 1)),
        fillColor: this.pink,
        prefixIcon: Icon(
          Icons.credit_card,
          color: this.pink,
        ),
        labelText: "National ID",
        hintText: "e.g 29804060302562",
        // labelStyle: TextStyle(
        //   color:labelgrey
        // ),
        contentPadding: EdgeInsets.all(12.0), // Inside box padding
      ),
      textInputAction: TextInputAction.next,
      validator: (nid) {
        if (nid.length < 1)
          return 'National ID is required';
        else if (nid.length < 14)
          return 'National ID should be 14 numbers';
        else if ((nid[0]) != "2" && (nid[0]) != "3") {
          print(nid[0]);
          return 'Invalid National ID';
        } else
          return null;
      },
      onSaved: (nid) => _national_id = nid.toString(),
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _nidFocusNode, _fnameFocusNode);
      },
    );
  }

  Widget FnameInput() {
    return TextFormField(
      focusNode: _fnameFocusNode,
      style: TextStyle(color: this.grey),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      inputFormatters: [
        WhitelistingTextInputFormatter(
            RegExp("[a-zA-Z]")), // only allows letters to be entered
      ],
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: this.pink, width: 1)),
        fillColor: this.pink,
        prefixIcon: Icon(
          Icons.person,
          color: this.pink,
        ),
        labelText: "First Name",
        hintText: "e.g Morgan",
        // labelStyle: TextStyle(
        //   color:labelgrey
        // ),
        contentPadding: EdgeInsets.all(12.0), // Inside box padding
      ),
      textInputAction: TextInputAction.next,
      validator: (fname) {
        Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
        RegExp regex = new RegExp(pattern);
        if (fname.length < 1)
          return 'First Name is required';
        else if (fname.length > 25)
          return 'Too long';
        else if (!regex.hasMatch(fname))
          return 'Invalid First Name';
        else
          return null;
      },
      onSaved: (fname) => _first_name = fname,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _fnameFocusNode, _mnameFocusNode);
      },
    );
  }

  Widget MnameInput() {
    return TextFormField(
      focusNode: _mnameFocusNode,
      style: TextStyle(color: this.grey),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      inputFormatters: [
        WhitelistingTextInputFormatter(
            RegExp("[a-zA-Z]")), // only allows letters to be entered
      ],
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: this.pink, width: 1)),
        fillColor: this.pink,
        prefixIcon: Icon(
          Icons.person,
          color: this.pink,
        ),
        labelText: "Middle Name",
        hintText: "e.g Ahmed",
        // labelStyle: TextStyle(
        //   color:labelgrey
        // ),
        contentPadding: EdgeInsets.all(12.0), // Inside box padding
      ),
      textInputAction: TextInputAction.next,
      validator: (mname) {
        Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
        RegExp regex = new RegExp(pattern);
        if (mname.length < 1)
          return 'Middle Name is required';
        else if (mname.length > 25)
          return 'Too long';
        else if (!regex.hasMatch(mname))
          return 'Invalid username';
        else
          return null;
      },
      onSaved: (mname) => _middle_name = mname,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _mnameFocusNode, _lnameFocusNode);
      },
    );
  }

  Widget LnameInput() {
    return TextFormField(
      focusNode: _lnameFocusNode,
      style: TextStyle(color: this.grey),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      inputFormatters: [
        WhitelistingTextInputFormatter(
            RegExp("[a-zA-Z]")), // only allows letters to be entered
      ],
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: this.pink, width: 1)),
        fillColor: this.pink,
        prefixIcon: Icon(
          Icons.person,
          color: this.pink,
        ),
        labelText: "Last Name",
        hintText: "e.g Morgan",
        // labelStyle: TextStyle(
        //   color:labelgrey
        // ),
        contentPadding: EdgeInsets.all(12.0), // Inside box padding
      ),
      textInputAction: TextInputAction.next,
      validator: (lname) {
        Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
        RegExp regex = new RegExp(pattern);

        if (lname.length < 1)
          return 'Last Name is required';
        else if (lname.length > 25)
          return 'Too long you stupid';
        else if (!regex.hasMatch(lname))
          return 'Invalid username';
        else
          return null;
      },
      onSaved: (lname) => _last_name = lname,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _lnameFocusNode, _emailFocusNode);
      },
    );
  }

  Widget EmailInput() {
    return TextFormField(
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: this.pink, width: 1)),
        fillColor: this.pink,
        prefixIcon: Icon(
          Icons.email,
          color: this.pink,
        ),
        labelText: "Email",
        hintText: "e.g abc@gmail.com",
        // labelStyle: TextStyle(
        //   color:labelgrey
        // ),
        contentPadding: EdgeInsets.all(12.0), // Inside box padding
      ),
      textInputAction: TextInputAction.next,
      validator: (email) =>
          EmailValidator.validate(email) ? null : "Invalid email address",
      onSaved: (email) => _email = email,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
      },
    );
  }

  Widget PasswordInput() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      keyboardType: TextInputType.text,
      obscureText: secured1,
      decoration: InputDecoration(
          labelText: "Password",
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: this.pink, width: 1)),
          fillColor: this.pink,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                secured1 = !secured1;
              });
            },
            child: Icon(secured1 ? Icons.visibility_off : Icons.visibility),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: this.pink,
          )),
      textInputAction: TextInputAction.next,
      validator: (password) {
        //Minimum eight characters, at least one uppercase letter, one lowercase letter and one number:
        Pattern pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(password)) {
          toastMessage(
              "Password should be:\nMinimum six characters\nAt least one uppercase letter,\nOne lowercase letter\n one number\n and one secial char");
          return 'Invalid password Format';
        } else {
          _password = password;
          return null;
        }
      },
      onSaved: (password) => _password = password,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _passwordFocusNode, _repasswordFocusNode);
      },
    );
  }




  Widget RepasswordInput() {
    return TextFormField(
      focusNode: _repasswordFocusNode,
      keyboardType: TextInputType.text,
      obscureText: secured2,
      decoration: InputDecoration(
          labelText: "Re-Password",
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: this.pink, width: 1)),
          fillColor: this.pink,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                secured2 = !secured2;
              });
            },
            child: Icon(secured2 ? Icons.visibility_off : Icons.visibility),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: this.pink,
          )),
      textInputAction: TextInputAction.next,
      validator: (repassword) {
        Pattern pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(repassword))
          return 'Invalid password Format';
        else if (repassword != _password) {
          return 'Re-password doesn\'t match password';
        } else
          return null;
      },
      onSaved: (repassword) => _re_password = repassword,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _repasswordFocusNode, _phoneFocusNode);
      },
    );
  }




  Widget Phone_Input() {
    return TextFormField(
      focusNode: _phoneFocusNode,
      maxLength: 11,
      style: TextStyle(color: this.grey),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.number,
      //controller: MaskedTextController(mask: "(000) 000-00000"),
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: this.pink, width: 1)),
            // counterText: "",
        fillColor: this.pink,
        prefixIcon: Icon(
          Icons.phone,
          color: this.pink,
        ),
        labelText: "Phone ",
        hintText: "e.g 01287473131",
        // labelStyle: TextStyle(
        //   color:labelgrey
        // ),
        contentPadding: EdgeInsets.all(12.0), // Inside box padding
      ),
      textInputAction: TextInputAction.next,
      validator: (phone) {
        if (phone.length < 1)
        return 'Please enter a phone number';
          else if (phone.length < 8)
          return 'Invalid Phone Numbers';
        else if (phone.length > 15)
          return 'Invalid Phone Numberx';
        else
          return null;
      },
      onSaved: (phone) => _phone = phone,
      onFieldSubmitted: (_) {
        //fieldFocusChange(context, _phoneFocusNode, _cityFocusNode);
        _cityDialogBox(context);
      },
    );
  }




  String cityvalue;

  Widget city_Input() {
    return TextFormField(
      focusNode: _cityFocusNode,
      onTap: () async {
        await fetchcities().then((value) {
      _cities.addAll(value);
      setState(() {
        _citiessearched=[];
        _citiessearched.addAll(value);
      });
        _cityDialogBox(context);
        });
      },
      style: TextStyle(color: this.grey),
      readOnly: true,
      controller: TextEditingController()..text = cityvalue, 
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: this.pink, width: 1)),
        fillColor: this.pink,
        prefixIcon: Icon(
          Icons.location_city,
          color: this.pink,
        ),
        labelText: "City",
        hintText: "e.g Cairo",
        // labelStyle: TextStyle(
        //   color:labelgrey
        // ),
        contentPadding: EdgeInsets.all(12.0), // Inside box padding
      ),
      textInputAction: TextInputAction.next,
      validator: (city) {
        if (city.length < 1) return 'Please choose a city';
      },
      //onSaved: (city) => _city = city,
      onFieldSubmitted: (_) {
        _cityDialogBox(context);

      },
    );
  }










String areavalue;

  Widget area_Input() {
    return TextFormField(
      focusNode: _areaFocusNode,
      onTap:  () async {
        await fetchAreas(_city.toString()).then((value) {
                 _areas.addAll(value);
                 setState(() {
                _areassearched=[];
                _areassearched.addAll(value);
                });
              });
        _areaDialogBox(context);
      },
      style: TextStyle(color: this.grey),
      readOnly: true,
      controller: TextEditingController()..text = areavalue,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: this.pink, width: 1)),
        fillColor: this.pink,
        prefixIcon: Icon(
          Icons.location_searching,
          color: this.pink,
        ),
        labelText: "Area",
        hintText: "e.g Maadi",
        // labelStyle: TextStyle(
        //   color:labelgrey
        // ),
        contentPadding: EdgeInsets.all(12.0), // Inside box padding
      ),
      textInputAction: TextInputAction.next,
      validator: (area) {
        if (area.length < 1) return 'Please choose an area';
      },
      //onSaved: (area) => _area = area,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _areaFocusNode, _streetFocusNode);
      },
    );
  }








  Widget StreetInput() {
    return TextFormField(
      focusNode: _streetFocusNode,
      style: TextStyle(color: this.grey),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      inputFormatters: [
        WhitelistingTextInputFormatter(
          //Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
            RegExp("^([A-Za-z0-9 _]*)")), 
      ],
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: this.pink, width: 1)),
        fillColor: this.pink,
        prefixIcon: Icon(
          Icons.map,
          color: this.pink,
        ),
        labelText: "Street",
        hintText: "e.g El-Tayaran St.",
        contentPadding: EdgeInsets.all(12.0), // Inside box padding
      ),
      textInputAction: TextInputAction.done,
      validator: (street) {
        if (street.length < 1)
          return 'Street is required';
        else if (street.length > 50)
          return 'Too long you stupid';
        else
          return null;
      },
      onSaved: (street) => _street = street,
    );
  }

  Container SubmitButton() {
    return Container(
      width: MediaQuery.of(context).size.width * (4 / 5),
      height: 45,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: RaisedButton(
        focusNode: _signUpFocusnode,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          //side: BorderSide(color: Colors.red),
        ),
        child: Text(
          "signup",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        color: pink,
        // color: Theme.of(context).primaryColor,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            // toastMessage(
            //     "Welcome $_first_name $_middle_name\nYou have been signed up");
          }
          //handle_National_Id();
          handleSignUp(context);

        
        },
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        fontSize: 16.0);
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }



  //returns list of Wigdets each containing a City Row
  List<Widget> getCityOption() {
    List<Widget> options = new List();
    for (int i = 0; i < _citiessearched.length; i++)
      options.add(new SimpleDialogOption(
          onPressed: () {
            _city = _citiessearched[i].citycode.toString();
            //fetchAreas(_citiessearched[i].citycode.toString());
            fieldFocusChange(context, _cityFocusNode, _areaFocusNode);
            //_areaDialogBox(context);
            setState(() {
              cityvalue = _citiessearched[i].cityname.toString();
              //fetchAreas(_citiessearched[i].citycode.toString());
              // fetchAreas(_citiessearched[i].citycode.toString()).then((value) {
              //    _areas.addAll(value);
              // });
            });
           FocusScope.of(co).requestFocus(new FocusNode());
          Navigator.pop(co,i);
            print(i); //here passing the index to be return on item selection
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.location_city, color: this.pink),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(_citiessearched[i].cityname),
                ),
                new SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ) //)
          ));
    return options;
  }









//returns list of Wigdets each containing a City Row
  List<Widget> getAreaOption() {
    List<Widget> options = new List();
    for (int i = 0; i < _areassearched.length; i++)
      options.add(new SimpleDialogOption(
          onPressed: () {
            _area = _areassearched[i].areacode.toString();
            fieldFocusChange(context, _areaFocusNode, _streetFocusNode);
            setState(() {
              areavalue = _areassearched[i].areaname.toString();
            });
            Navigator.pop(co, i);
            print(i); //here passing the index to be return on item selection
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.location_searching, color: this.pink),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(_areassearched[i].areaname),
                ),
                new SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ) //)
          ));
    return options;
  }







// Show  Dialog function
  void _cityDialogBox(context) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {},
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        // return alert dialog object
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              title: Text(
                "Choose City",
                style: TextStyle(
                  color: this.pink,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28.0))),
              content: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                child: Column(
                  children: <Widget>[
                    citySearchBar(),
                    Container(
                      height: MediaQuery.of(context).size.height / 2.5 - 53,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: getCityOption(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }









// Show  Dialog function
  void _areaDialogBox(context) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {},
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        // return alert dialog object
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              title: Text(
                "Choose Area",
                style: TextStyle(
                  color: this.pink,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28.0))),
              content: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                child: Column(
                  children: <Widget>[
                    areaSearchBar(),
                    Container(
                      height: MediaQuery.of(context).size.height / 2.5 - 53,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: getAreaOption(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }








  String citysearchtxt;
  citySearchBar() {
    return (Container(
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        textInputAction: TextInputAction.search,
        controller: TextEditingController()..text = citysearchtxt,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: this.pink, width: 1)),
          fillColor: this.pink,
          prefixIcon: Icon(
            Icons.search,
            color: this.pink,
          ),

          hintText: "Search for City",
          contentPadding: EdgeInsets.all(12.0), // Inside box padding
        ),
        onChanged: (txt) {
          citysearchtxt = txt;
          this._citiessearched = [];
          this._cities.forEach((city) {
            if (city.cityname.toLowerCase().contains(txt)) {
              this._citiessearched.add(city);
            }

            // else
          });
          setState(() {
            if (txt == "") this._citiessearched = _cities;
            //this._citiessearched = this._citiessearched;
            getCityOption();
          });
        },
      ),
    ));
  }









  
  String areasearchtxt;
  areaSearchBar() {
    return (Container(
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        textInputAction: TextInputAction.search,
        controller: TextEditingController()..text = areasearchtxt,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: this.pink, width: 1)),
          fillColor: this.pink,
          prefixIcon: Icon(
            Icons.search,
            color: this.pink,
          ),

          hintText: "Search for Area",
          contentPadding: EdgeInsets.all(12.0), // Inside box padding
        ),
        onChanged: (txt) {
          areasearchtxt = txt;
          this._areassearched = [];
          this._areas.forEach((a) {
            if (a.areaname.toLowerCase().contains(txt)) {
              this._areassearched.add(a);
            }

            // else
          });
          setState(() {
            if (txt == "") this._areassearched = _areas;
            getAreaOption();
          });
        },
      ),
    ));
  }







  

  handleSignUp(BuildContext context) async {
    var data = {
      "national_id": this._national_id,
      "first_name": this._first_name,
      "middle_name": this._middle_name,
      "last_name": this._last_name,
      "email": this._email,
      "password": this._password,
      //"gender": this._gender,
      //"birth_date": this._bDate,
      "city": this._city,
      "phone_num": this._phone,
      "area": this._area,
      "street": this._street,
      "role": "0",
      "verification": 0,
    };
    //if (this._password == this._re_password) {
    var response = await Apis.saveUserApi(data);
    if (response['message'] == 'success') {
     login();
      // nidexists = false;
      // emailexists = false;
      
      toastMessage(
          "Welcome $_first_name $_middle_name\nYou have been signed up");
    } else {
      toastMessage(
          response['message']);
    }
  }

  Container CreateSignUpForm(BuildContext context) {
  
    return (Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Nid_Input(),
                  FnameInput(),
                  MnameInput(),
                  LnameInput(),
                  EmailInput(),
                  PasswordInput(),
                  RepasswordInput(),
                  Phone_Input(),
                  //CustomDropDownWidget(),
                  city_Input(),
                  area_Input(),
                  StreetInput(),

                  SizedBox(
                    height: 40,
                  ),

                  SubmitButton()
                ],
              ),
            ),
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 45,
          //   margin: EdgeInsets.only(top: 30),
          //   child: RaisedButton(
          //     child: Text(
          //       "signup",
          //       style: TextStyle(
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 18),
          //     ),
          //     color: this.pink,
          //     onPressed: () {
          //       handleSignUp(context);
          //     },
          //   ),
          // ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 45,
          //   margin: EdgeInsets.only(top: 10),
          //   child: RaisedButton(
          //     child: Text(
          //       "signin",
          //       style: TextStyle(
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 18),
          //     ),
          //     color: this.pink,
          //     onPressed: () {
          //       Navigator.pushNamed(context, '/signin');
          //     },
          //   ),
          // ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
     setState(() {
              co=context;
            });
    return Scaffold(
        appBar: AppBar(
            backgroundColor: this.pink,
            title: Text("Sign Up"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              FlatButton(
                padding: EdgeInsets.all(0),
                textColor: Colors.white70,
                onPressed: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
   
                },
                child: Row(
                  children: <Widget>[
                    Text("Skip"),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      tooltip: 'Skip',
                      onPressed: () {
                       Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
   
                      },
                    ),
                  ],
                ),
              )
            ]),
        //     appBar: AppBar(
        //   title: Text("Sign Up"),
        //   backgroundColor: this.pink,
        //   leading: IconButton(
        //     icon: Icon(null),
        //   ),
        //   actions: <Widget>[

        //     Padding(
        //   padding: EdgeInsets.only(right: 20.0),
        //   child:GestureDetector(
        //     onTap: () {},
        //     child: Icon(
        //       Icons.search,
        //       size: 26.0,
        //     ),))

        //   ],
        // ),
       
        body: new GestureDetector(
          onTap: () {
          
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
              child: Container(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 25),
                    child:Image(
                      image: AssetImage('assets/images/signIn.png'),
                      height: 200,
                      width: 400,
                    ),
                  ),
                ),
                CreateSignUpForm(context),
              ],
            ),
          )),
        ));
  }
  login() async {
    setState(() {
      Apis.upemail=_email;
    });
  var response = await Apis.login();
   if(response==200){
   Navigator.push(context,
                          MaterialPageRoute(builder: (context) => box2()));
   }
  

}
}
