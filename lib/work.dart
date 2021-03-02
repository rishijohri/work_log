import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_work.dart';
import 'device_storage.dart';


class WorkTileClass extends State<WorkTile> {
  final IconData starred;
  var starring;
  final subController = TextEditingController();
  var subTaskPresent = <String>[];
  var _pads = 10.0;
  bool stay = true ;
  IconData starIcon;
  WorkTileClass({
    this.starred,
  });
  @override
  void initState() {
    super.initState();
    starring = widget.importance;
    starIcon = starCheck(starring);
  }

  String titleCheck(String title) {
    String obi;
    int maximo = 23;
    if (title.length > maximo) {
      obi = title.substring(0, (maximo - 3)) + "...";
    } else if (title.length < maximo) {
      obi = title;
      for (int i = title.length; i < maximo; i++) {
        obi += " ";
      }
    } else {
      obi = title;
    }
    return obi;
  }

  bool visibleCheck(bool vis) {
    if (vis == null) {
      return true;
    } else {
      return vis;
    }
  }

  IconData starCheck(bool imp) {
    starring = widget.importance;
    if (imp == true) {
      return Icons.star;
    } else {
      return Icons.star_border;
    }
  }

  String dueCheck() {
    String submit = 'Due Date: ';
    if (widget.currentDate.year == widget.dueDate.year) {
      if (widget.currentDate.month == widget.dueDate.month) {
        submit += widget.dueDate.day.toString();
      } else {
        submit += widget.dueDate.day.toString() +
            ' / ' +
            widget.dueDate.month.toString();
      }
    } else {
      submit += widget.dueDate.day.toString() +
          ' / ' +
          widget.dueDate.month.toString() +
          ' / ' +
          widget.dueDate.year.toString();
    }
    var min;
    if (widget.dueDate.minute < 10) {
      min = '0' + widget.dueDate.minute.toString();
    } else {
      min = widget.dueDate.minute.toString();
    }
    submit += ' by: ' + widget.dueDate.hour.toString() + ':' + min;
    return submit;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: stay,
      child: AnimatedContainer(
        margin: EdgeInsets.only(bottom: _pads, top: _pads),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).primaryColor, width: 3),
        ),
        duration: Duration(milliseconds: 650),
        child: InkWell(
          borderRadius: BorderRadius.circular(19),
          splashColor: Colors.purpleAccent,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute<Null>(builder: (BuildContext context) {
              return DetailWork(
                index: widget.index,
                title: widget.title,
              );
            }));
          },
          child: Column(
            children: <Widget>[
            Wrap(
              children: <Widget>[
                Visibility(
                  visible: visibleCheck(widget.showStar),

                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, top: 10.0, right: 20.0, bottom: 19.0),
                    child: IconButton(
                      icon: Center(
                        child: Icon(
                          starIcon,
                          color: Colors.teal,
                          size: 40,
                        ),
                      ),
                      onPressed: _starConvert,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
                  child: Text(
                    titleCheck(widget.title),
                    style: Theme.of(context).textTheme.headline5,
                    softWrap: true,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.done,
                    color: Colors.purple,
                    size: 39,
                  ),
                  onPressed: () async {
                    setState(() {
                      stay = false;
                      removeWork(widget.index);
                      _pads = 0;
                    });
                    // *******************Shared Pref removal*********************
                  },
                )
              ],
            ),
            Divider(thickness: 3,),
            Wrap(
              children: <Widget>[
                Text(
                  dueCheck(),
                  softWrap: true,
                ),
                Container(
                  width: 10,
                ),

                Container(
                  width: 20,
                ),
              ],
            ),
              Container(
                height: 10,
              )
          ],
          ),
        ),
      ),
    );
  }

  void _starConvert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titList = prefs.getStringList('titleStorage') ?? ['Welcome'];
    int index = titList.indexOf(widget.title);
    List<String> impList = prefs.getStringList('importantList') ?? ['yes'];
    setState(() {
      if (impList[index] == 'yes') {
        impList[index] = 'no';
        prefs.setStringList('importantList', impList);
        starIcon = Icons.star_border;
      } else {
        impList[index] = 'yes';
        prefs.setStringList('importantList', impList);
        starIcon = Icons.star;
      }
    });
  }
}

// ignore: must_be_immutable
class WorkTile extends StatefulWidget {
  final String title;
  final String description;
  final DateTime currentDate;
  final DateTime dueDate;
  final int index;
  bool importance;
  bool showStar;
  WorkTile({
    this.title,
    this.importance,
    this.description,
    this.showStar,
    this.currentDate,
    this.dueDate,
    this.index,
  });
  @override
  WorkTileClass createState() => new WorkTileClass();
}
