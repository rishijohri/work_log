import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';

class DetailWork extends StatefulWidget {
  final int index;
  final String title;
  const DetailWork({
    Key key,
    this.index,
    this.title,
  }) : super(key: key);

  @override
  _DetailWorkState createState() => _DetailWorkState();
}

class _DetailWorkState extends State<DetailWork> {
  String tit;
  final subController = TextEditingController();

  Future<String> getTitles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titList = prefs.getStringList('titleStorage') ?? ['Welcome'];
    titList.indexOf(widget.title);
    print(titList);
    return titList[titList.indexOf(widget.title)];
  }

  Future<String> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> descList = prefs.getStringList('descriptionStorage') ??
        ['Here you can see a detailed description of your work'];
    List<String> titList = prefs.getStringList('titleStorage') ?? ['Welcome'];
    titList.indexOf(widget.title);
    return descList[titList.indexOf(widget.title)];
  }

  Future<List<String>> subTasks() async {
    String tit = await getTitles();
    print(tit);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var subList = prefs.getStringList(tit) ?? ['Add Tasks Here'];
    return subList;
  }

  Future<TextDecoration> decorator(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tit = await getTitles();
    var subList = prefs.getStringList(tit + 'decor12') ?? ['n'];
    print(subList);
    if (subList[index] == 'y') {
      return TextDecoration.lineThrough;
    } else {
      return TextDecoration.none;
    }
  }

  Future<Widget> subList() async {
    var tit = await getTitles();
    var subList = await subTasks();
    print(subList);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var subs = prefs.getStringList(tit + 'decor12') ?? ['n'];
    List<TextDecoration> lineth = List.generate(subList.length, (index) {
      if (subs[index] == 'y') {
        return TextDecoration.lineThrough;
      } else {
        return TextDecoration.none;
      }
    });
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        return InkWell(
          onTap: () {
            setState(() {
              if (subs[i] == 'n') {
                subs[i] = 'y';
                prefs.setStringList(tit + 'decor12', subs);
              } else {
                subs[i] = 'n';
                prefs.setStringList(tit + 'decor12', subs);
              }
              print(subs);
            });
          },
          onLongPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var subList = await subTasks();
            var tit = await getTitles();
            var subs = prefs.getStringList(tit + 'decor12') ?? ['n'];
            setState(() {
              subList.removeAt(i);
              subs.removeAt(i);
              prefs.setStringList(tit + 'decor12', subs);
              prefs.setStringList(tit, subList);
            });
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              subList[i],
              style: TextStyle(
                fontStyle: FontStyle.italic,
                decoration: lineth[i],
                fontSize: 25,
                color: Colors.deepPurple
              ),
            ),
          ),
        );
      },
      itemCount: subList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    getTitles();
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            var data;
            if (snapshot.hasData) {
              data = snapshot.data;
            } else if (snapshot.hasError) {
              data = 'error loading';
            } else {
              data = 'sorry critical error';
            }
            return Text(
              data,
              style: Theme.of(context).textTheme.headline4,
            );
          },
          future: getTitles(),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                var data;
                if (snapshot.hasData) {
                  data = snapshot.data;
                } else if (snapshot.hasError) {
                  data = 'error loading';
                } else {
                  data = 'sorry critical error';
                }
                return Text(
                  data,
                  style: Theme.of(context).textTheme.headline5,
                );
              },
              future: getDetails(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: subController,
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.headline5,
                      labelText: 'Sub Tasks',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 25,
                    ),
                  ),
                  flex: 5,
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      print('sub task addition');
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var subList = await subTasks();
                      var tit = await getTitles();
                      var subs = prefs.getStringList(tit + 'decor12') ?? ['n'];
                      if (subController.text != null) {
                        setState(() {
                          subList.add(subController.text);
                          prefs.setStringList(tit, subList);
                          subs.add('n');
                          prefs.setStringList(tit + 'decor12', subs);
                          subController.text = '';
                        });
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      child: Icon(
                        Icons.add_circle,
                        color: Theme.of(context).primaryColor,
                        size: 52,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                var data;
                if (snapshot.hasData) {
                  data = snapshot.data;
                } else if (snapshot.hasError) {
                  data = Container(
                    child: Text('has error'),
                  );
                } else {
                  data = Container(
                    child: Text('destroyed'),
                  );
                }
                return data;
              },
              future: subList(),
            ),
          )
        ],
      ),
    );
  }
}
