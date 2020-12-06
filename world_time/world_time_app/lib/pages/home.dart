import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);

    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$position.latitude,$position.longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

//  @override
//  void initState() {
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    // set background image
    String bgImage = data['isDaytime'] ? 'sun.jpg' : 'moon.jpg';
    Color bgColor = data['isDaytime'] ? Colors.blue : Colors.indigo[700];
    Color txtColor = data['isDaytime'] ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/$bgImage'),
            fit: BoxFit.cover,
          )),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120.0, 0, 0),
            child: Column(
              children: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      _getCurrentLocation();
                    },
                    icon: Icon(
                      Icons.location_on,
                      color: txtColor,
                    ),
                    label: Text(
                      "Show Current Location",
                      style: TextStyle(
                        color: txtColor,
                        fontSize: 18.0,
                        letterSpacing: 2.0,
                      ),
                    )),
                FlatButton.icon(
                  onPressed: () async {
                    dynamic result =
                        await Navigator.pushNamed(context, '/location');
                    if (result != null) {
                      setState(() {
                        data = {
                          'time': result['time'],
                          'location': result['location'],
                          'isDaytime': result['isDaytime'],
                          'flag': result['flag']
                        };
                      });
                    }
                  },
                  icon: Icon(Icons.edit_location, color: txtColor),
                  label: Text(
                    'Edit Location',
                    style: TextStyle(
                      color: txtColor,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      data['location'],
                      style: TextStyle(
                        fontSize: 28.0,
                        letterSpacing: 2.0,
                        color: txtColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(data['time'],
                    style: TextStyle(fontSize: 66.0, color: txtColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
