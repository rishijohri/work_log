import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'star_page.dart';
import 'work.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'new_work.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'device_storage.dart';
final myKeyOne = GlobalKey<AnimatedListState>();
final myKeyTwo = GlobalKey<AnimatedListState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
    removeWorkString(payload);
  }); // dance monkey
  runApp(MaterialApp(
    title: 'Work Logger',
    theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        backgroundColor: Colors.white,
        textSelectionColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(headline4: TextStyle(color: Colors.white70))),
    home: Skeleton(),

    debugShowCheckedModeBanner: false,
  ));
}

class Skeleton extends StatefulWidget {
  final int start;

  const Skeleton({Key key, this.start:0,}) : super(key: key);
  @override
  _SkeletonState createState() => _SkeletonState();
}

var widgetHolder = <Widget>[
  MyHomePage(title: 'Work Logger', numberTasks: 100,),
  StarPage(),

];

class _SkeletonState extends State<Skeleton> {
  int cont = 0;
  void _selectionNavigate(int i) {
    setState(() {
      cont = i;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          BottomNavigationBar(items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.home
              ),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                    Icons.star
                ),
                title: Text('Star Work')
            ),
          ],
            onTap: _selectionNavigate,
            currentIndex: cont,

          ),
          Positioned(
            bottom: 15,
          child :Container(
              width: 75,
              height: 75,

              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: () {
                    print('pressed float');
                    Navigator.push(context,
                        MaterialPageRoute<Null>(builder: (BuildContext context) {
                          return WorkCreate();
                        }));
                  },
                  tooltip: 'Add Task',
                  child: Icon(
                    Icons.add,

                  ),

                ),
              ),
            )
          ),

        ]
      ),
      body: widgetHolder[cont],
    );
  }
}


class MyHomePage extends StatefulWidget {
  final numberTasks;
  MyHomePage({
    Key key,
    this.title,
    this.numberTasks: 100,
  }) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List<String> drawerQuotes = [
    "Achieve what You want",
    "Never miss a DeadLine",
    "Never miss any Detail",
    "Best of Luck for anything",
    "Be Prepared for anything",
    "Look only at What's important"
  ];
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');
  @override
  void initState() {
    super.initState();
    print('home loaded');
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    _cancelAllNotifications();
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(
                      title: 'My Home Page',
                      numberTasks: 100,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  title: 'Work Logger',
                  numberTasks: 100,
                )),
      );
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  Future<void> _scheduleNotification(
      int index, String title, DateTime data) async {
    var scheduledNotificationDateTime = data;
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'app_icon',
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        index,
        title,
        'Due Date Reached',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: title);
  }



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
    var date = DateTime(
      int.parse(dueyear[i]),
      int.parse(duemonth[i]),
      int.parse(dueday[i]),
      int.parse(duehour[i]),
      int.parse(dueminute[i]),
    );
    if (date.difference(DateTime.now())>Duration(seconds: 0)) {
      if (titList.length > i) {
        _scheduleNotification(i, titList[i], date);
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
        );
      } else {
        return Container(
          width: 0,
          height: 0,
        );
      }
    } else {
      removeWork(i);
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Widget _buildHomePageOne() {
    return AnimatedList(key: myKeyOne,
      itemBuilder: (context, i, animation) {
        if (i.isOdd) {
          return FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              var info;
              if (snapshot.hasData) {
                info = snapshot.data;
              } else {
                info = Container(
                  width: 0,
                  height: 0,
                );
              }
              return info;
            },
            future: workListComponent(i),
          );
        } else {
          return Container(width: 0,
            height: 0,);
        }
      },
      initialItemCount: widget.numberTasks,
    );
  }

  Widget _buildHomePageTwo() {
    return AnimatedList(key: myKeyTwo,
      itemBuilder: (context, i, animation) {
      if (i.isEven) {
        return InkWell(
          onLongPress: () {
            AnimatedList.of(context).removeItem(
                i, (context, animation) => null);
          },
          child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              var info;
              if (snapshot.hasData) {
                info = snapshot.data;
              } else {
                info = Container(
                  width: 0,
                  height: 0,
                );
              }
              return info;
            },
            future: workListComponent(i),
          ),
        );
      } else {
        return Container(width: 0,
        height: 0,);
      }
    },
    initialItemCount: widget.numberTasks,
    );
  }

  @override
  Widget build(BuildContext context) {
    final listViewOne = Container(
      padding: EdgeInsets.only(top: 12.0, left: 2, right: 5),
      child: _buildHomePageOne(),
    );
    final listViewTwo = Container(
      padding: EdgeInsets.only(top: 12.0, left: 5, right: 2),
      child: _buildHomePageTwo(),
    );
    return Scaffold(

      body: Row(
        children: <Widget>[
          Expanded(child: listViewTwo),
          Expanded(child: listViewOne)
        ],

      ),
      backgroundColor: Theme.of(context).backgroundColor,

    );
  }
}

