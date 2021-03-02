import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'device_storage.dart';
import 'work.dart';

class StarPage extends StatefulWidget {
  @override
  _StarPageState createState() => _StarPageState();
}

class _StarPageState extends State<StarPage> {
  Future<Widget> workListComponent(int i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titList = prefs.getStringList('titleStorage') ?? ['Welcome'];
    List<String> descList = prefs.getStringList('descriptionStorage') ??
        ['Here you can see a detailed description of your work'];
    List<String> impList = prefs.getStringList('importantList') ?? ['no'];
    List<String> dueyear = prefs.getStringList('dueyear') ?? ['2030'];
    List<String> duemonth = prefs.getStringList('duemonth') ?? ['1'];
    List<String> dueday = prefs.getStringList('dueday') ?? ['1'];
    List<String> duehour = prefs.getStringList('duehour') ?? ['1'];
    List<String> dueminute = prefs.getStringList('dueminute') ?? ['1'];
    if (titList.length > i) {
      return WorkTile(
        title: titList[i],
        description: descList[i],
        importance: truthConvertStoB(impList[i]),
        dueDate: DateTime(
          int.parse(dueyear[i]),
          int.parse(duemonth[i]),
          int.parse(dueday[i]),
          int.parse(duehour[i]),
          int.parse(dueminute[i]),
        ),
        currentDate: DateTime.now(),
        index: i,
        showStar: false,
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Future<Widget> selectedItem(int i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> impList;
    impList = prefs.getStringList('importantList') ?? ['no'];
    if (impList.length > i) {
      if (impList[i] == 'yes') {
        return workListComponent(i);
      } else {
        return Container(
          width: 0,
          height: 0,
        );
      }
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Widget starlist() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        return FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            var dat;
            if (snapshot.hasData) {
              dat = snapshot.data;
            } else {
              dat = Container(
                width: 0,
                height: 0,
              );
            }
            return dat;
          },
          future: selectedItem(i),
        );
      },
      itemCount: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: starlist(),
        padding: EdgeInsets.all(12),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
