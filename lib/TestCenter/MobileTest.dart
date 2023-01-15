import 'package:flutter/material.dart';
import 'package:flutterapp/common/apis.dart';
import 'mobileByLocation.dart';
import 'mobileByName.dart';
import 'mobileDetails.dart';

int count = 0;

class MobileList extends StatefulWidget {
  @override
  _MobileList createState() => _MobileList();
}

class _MobileList extends State<MobileList> {
  List<dynamic> hospitals = [];
  List<dynamic> originalHospitals = [];
  List<dynamic> hospstandalone = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      istate();
      showDefaultSnackbar(context);
    });
  }

  Widget build(BuildContext context) {
    return new RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.pinkAccent,
          //   title: Text(
          //     'Static test center List',
          //     style: TextStyle(
          //       fontSize: 20.0,
          //       fontWeight: FontWeight.bold,
          //      ),
          //   ),
          //   centerTitle: true,
          // ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  _searchBar(),
                  hospstandalone != null
                      ? Column(children: <Widget>[
                          ...hospstandalone.map<Widget>((item) {
                            return _listItem(
                              item,
                            );
                          }).toList(),
                        ])
                      : Center(
                          child: Text(
                            " ",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ));
  }

  _searchBar() {
    return (Container(
      margin: EdgeInsets.all(20),
      child: TextField(
        decoration: InputDecoration(
          hintText: "search for test center ",
          prefixIcon: Icon(
            Icons.search,
            color: Colors.pinkAccent,
          ),
          suffixIcon: IconButton(
              icon: Icon(Icons.filter_list),
              iconSize: 40,
              color: Colors.pink[400],
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => SimpleDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.sort),
                          iconSize: 20,
                          color: Colors.pink[400],
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'Sort By',
                          style:
                              TextStyle(fontSize: 20, color: Colors.pink[400]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    children: <Widget>[
                      ListTile(
                        title: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MobileBySortedAlphab()));
                          },
                          child: Text(
                            'Alphabetic order',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[400]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      ListTile(
                        title: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MobileSortedLocation()));
                          },
                          child: Text(
                            'nearest Location',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[400]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide:
                BorderSide(color: Colors.pinkAccent.withOpacity(.2), width: 1),
          ),
        ),
        onChanged: (txt) {
          this.hospitals = [];
          this.originalHospitals.forEach((hospital) {
            if (hospital["mobileCenter"]["test_center"]["medical_org"]["name"]
                .toString()
                .toLowerCase()
                .contains(txt)) {
              this.hospitals.add(hospital);
            }
          });
          setState(() {
            this.hospitals = this.hospitals;
          });
        },
      ),
    ));
  }

  _listItem(
    dynamic hospitalItemB,
  ) {
    String a;
    String b;
    String c;

    if (hospitalItemB["nearestSchedule"] != null) {
      a = hospitalItemB["nearestSchedule"]["street_id"]["name"] ??
          'lolololololo';
      b = hospitalItemB["nearestSchedule"]["street_id"]["area"]["name"] ??
          'lolololololo';
      c = hospitalItemB["nearestSchedule"]["street_id"]["area"]["city"]
              ["name"] ??
          'lolololololo';
    } else {
      a = "no street available ";
      b = ",no area available ";
      c = ",no city available";
    }
    return Card(
        child: new InkWell(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => MobileDetails(),
                settings: RouteSettings(
                  arguments: hospitalItemB,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100,
              width: 350,
              child: Image.network(
                hospitalItemB["mobileCenter"]["test_center"]["medical_org"]
                        ["pic_url"] ??
                    "htkm.kgm",
                //[0]["test_center"]["medical_org"]["pic_url"] ,

                fit: BoxFit.fitWidth,
              ),
            ),
            Text(
              hospitalItemB["mobileCenter"]["test_center"]["medical_org"]
                      ["name"] ??
                  'null bygib null kda ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              a + b + c,
              // hospitalItemB["nearestSchedule"]["street_id"]["name"]+", "+hospitalItemB["nearestSchedule"]["street_id"]["area"]["name"]+", "+hospitalItemB["nearestSchedule"]["street_id"]["area"]["city"]["name"] ?? 'lolololololo',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    ));
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));
    await mess();
    await istate();
    setState(() {
      count += 5;
    });

    return null;
  }

  istate() async {
    int camel = 0;
    count = count + camel;
    print(count);
    dynamic data = await Apis.getMobile2();
    this.originalHospitals = data;
    this.hospstandalone = data[2]["mobileTestCenters"];
    setState(() {
      this.hospitals = data;
    });
  }

  mess() async {
    dynamic data = await Apis.getMobile2();
    this.originalHospitals = data;
    setState(() {
      this.hospitals = data;
    });
  }

  showDefaultSnackbar(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 8000));
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(hospitals[1]["tip"]),
        action: SnackBarAction(
          label: 'ok',
          onPressed: () {},
        ),
      ),
    );
  }
}
