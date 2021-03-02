import 'package:shared_preferences/shared_preferences.dart';
import 'work.dart';

var workTiles = <WorkTile>[];
var workTilesWO = <WorkTile>[];
updateWork(String title, String description, DateTime dueDate) async {
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
  dueyear.add(dueDate.year.toString());
  duemonth.add(dueDate.month.toString());
  dueday.add(dueDate.day.toString());
  duehour.add(dueDate.hour.toString());
  dueminute.add(dueDate.minute.toString());
  titList.add(title);
  descList.add(description);
  impList.add(truthConvertBtoS(false));
  prefs.setStringList('titleStorage', titList);
  prefs.setStringList('descriptionStorage', descList);
  prefs.setStringList('importantList', impList);
  prefs.setStringList(title, ['Add Tasks Here']);
  prefs.setStringList('dueyear', dueyear);
  prefs.setStringList('duemonth', duemonth);
  prefs.setStringList('dueday', dueday);
  prefs.setStringList('duehour', duehour);
  prefs.setStringList('dueminute', dueminute);
}

workLength(var add) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> titList = prefs.getStringList('titleStorage') ?? ['Welcome'];
  add = titList.length;
}

removeWork(int i) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> titList = prefs.getStringList('titleStorage');
  List<String> descList = prefs.getStringList('descriptionStorage');
  List<String> impList = prefs.getStringList('importantList');
  List<String> dueyear = prefs.getStringList('dueyear') ?? ['2030'];
  List<String> duemonth = prefs.getStringList('duemonth') ?? ['1'];
  List<String> dueday = prefs.getStringList('dueday') ?? ['1'];
  List<String> duehour = prefs.getStringList('duehour') ?? ['1'];
  List<String> dueminute = prefs.getStringList('dueminute') ?? ['1'];
  prefs.remove(titList[i]);
  prefs.remove(titList[i] + 'decor12');
  titList.removeAt(i);
  descList.removeAt(i);
  impList.removeAt(i);
  dueyear.removeAt(i);
  duemonth.removeAt(i);
  dueday.removeAt(i);
  duehour.removeAt(i);
  dueminute.removeAt(i);
  prefs.setStringList('titleStorage', titList);
  prefs.setStringList('descriptionStorage', descList);
  prefs.setStringList('importantList', impList);
  prefs.setStringList('dueyear', dueyear);
  prefs.setStringList('duemonth', duemonth);
  prefs.setStringList('dueday', dueday);
  prefs.setStringList('duehour', duehour);
  prefs.setStringList('dueminute', dueminute);
}

removeWorkString(String tit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> titList = prefs.getStringList('titleStorage');
  List<String> descList = prefs.getStringList('descriptionStorage');
  List<String> impList = prefs.getStringList('importantList');
  List<String> dueyear = prefs.getStringList('dueyear') ?? ['2030'];
  List<String> duemonth = prefs.getStringList('duemonth') ?? ['1'];
  List<String> dueday = prefs.getStringList('dueday') ?? ['1'];
  List<String> duehour = prefs.getStringList('duehour') ?? ['1'];
  List<String> dueminute = prefs.getStringList('dueminute') ?? ['1'];
  int i = titList.indexOf(tit);
  prefs.remove(titList[i]);
  prefs.remove(titList[i] + 'decor12');
  titList.removeAt(i);
  descList.removeAt(i);
  impList.removeAt(i);
  dueyear.removeAt(i);
  duemonth.removeAt(i);
  dueday.removeAt(i);
  duehour.removeAt(i);
  dueminute.removeAt(i);
  prefs.setStringList('titleStorage', titList);
  prefs.setStringList('descriptionStorage', descList);
  prefs.setStringList('importantList', impList);
  prefs.setStringList('dueyear', dueyear);
  prefs.setStringList('duemonth', duemonth);
  prefs.setStringList('dueday', dueday);
  prefs.setStringList('duehour', duehour);
  prefs.setStringList('dueminute', dueminute);
}
String truthConvertBtoS(bool imp) {
  if (imp == true) {
    return 'yes';
  } else {
    return 'no';
  }
}

bool truthConvertStoB(String rep) {
  if (rep == 'yes') {
    return true;
  } else {
    return false;
  }
}

//Widget _buildTaskList() {
//  return ListView.builder(
//    itemBuilder: (BuildContext context, int index) {
//      return InkWell(
//          onTap: () async {
//            Navigator.push(context,
//                //detailTaskPage(index, titList, subTasks, descList)
//                MaterialPageRoute<Null>(builder: (BuildContext context) {
//                  return DetailWork(
//                    index: index,
//                  );
//                }));
//          },
//          child: Column(children: <Widget>[
//            Row(
//              children: <Widget>[
//                workTiles[index],
//                IconButton(
//                  icon: Icon(
//                    Icons.done_outline,
//                    color: Theme.of(context).primaryColor,
//                  ),
//                  onPressed: () async {
//                    destroyed.add(workTilesWO[index]);
//                    setState(() {
//                      workTiles.removeAt(index);
//                      workTilesWO.removeAt(index);
//                    });
//                    // *******************Shared Pref removal*********************
//                    _removeWork(index);
//                    SharedPreferences prefs =
//                    await SharedPreferences.getInstance();
//                    List<String> titList =
//                    prefs.getStringList('titleStorage');
//                    prefs.remove(titList[index]);
//                  },
//                )
//              ],
//            ),
//            Divider()
//          ]));
//    },
//    itemCount: workTiles.length,
//  );
//}


//
//appBar: AppBar(
//elevation: 7.0,
//title: Text(
//widget.title,
//style: Theme.of(context).textTheme.headline4,
//),
//centerTitle: true,
//actions: <Widget>[
//Padding(
//padding:
//EdgeInsets.only(left: 0.0, top: 0.0, right: 16.0, bottom: 0.0),
//child: IconButton(
//icon: Icon(
//Icons.notifications,
//color: Colors.white,
//size: 30,
//),
//onPressed: () async {
//print('pressed notification');
//await _checkPendingNotificationRequests();
//},
//),
//)
//],
//),