import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'device_storage.dart';
import 'main.dart';

class WorkCreate extends StatefulWidget {
  @override
  _WorkCreateState createState() => _WorkCreateState();
}

class _WorkCreateState extends State<WorkCreate> {
  var titleController = TextEditingController();
  var detController = TextEditingController();
  var _fromDate = DateTime.now();
  var _fromTime = TimeOfDay.fromDateTime(DateTime.now());
  List<String> defaults = [
    'finance',
    'Payments',
    'Premiums',
    'Office Work',
    'meeting',
    'Submissions',
    'Policy Renewal',
    'music',
    'dance',
    'family',
    'School',
    'List',
    'House Chores',
    'Daily Work',
  ];
  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(1990, 1),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime,
    );
    if (picked != null && picked != _fromTime) {
      setState(() {
        _fromTime = picked;
      });
    }
  }

  Widget easySelectionList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        return InkWell(
          onTap: () {
            setState(() {
              titleController.text += defaults[i];
            });
          },
          child: Container(
            child: Text(
              defaults[i],
              style: Theme.of(context).textTheme.bodyText1,
            ),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.teal)),
            margin: EdgeInsets.only(right: 6),
          ),
        );
      },
      scrollDirection: Axis.horizontal,
      itemCount: defaults.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Work',
          style: Theme.of(context).textTheme.headline4,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute<Null>(builder: (BuildContext context) {
              return Skeleton();
            }));
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.done_outline,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () async {
                var data = DateTime(_fromDate.year, _fromDate.month,
                    _fromDate.day, _fromTime.hour, _fromTime.minute);
                var curr = DateTime.now();
                var diff = data.difference(curr);
                var datat = Duration(minutes: 1);
                print(diff < datat);
                if (diff > datat && titleController.text != '') {
                  updateWork(titleController.text, detController.text, data);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return Skeleton();
                  }));
                } else if (diff<datat) {
                  return showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('Cannot enter a Task for Past'),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                height: 35,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).primaryColor),
                                child: Center(
                                  child: Text(
                                    'OK',
                                    style: TextStyle(fontSize: 15,
                                      color: Colors.white
                                    ),

                                  ),
                                ),
                              ))
                        ],
                      ));
                } else if (titleController.text == '') {
                  return showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('No title Entered'),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                height: 35,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).primaryColor),
                                child: Center(
                                  child: Text(
                                    'OK',
                                    style: TextStyle(fontSize: 15,
                                        color: Colors.white
                                    ),

                                  ),
                                ),
                              ))
                        ],
                      ));
                }
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.headline5,
                  labelText: 'Work Title',
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
            ),
            Container(
              margin: EdgeInsets.all(7),
              height: 30,
              child: easySelectionList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: detController,
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.headline5,
                  labelText: 'Short Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontSize: 25,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
              ),
            ),
            Container(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      _showDatePicker();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      height: 175,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 1)),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _fromDate.day.toString() +
                                  ' / ' +
                                  _fromDate.month.toString() +
                                  ' / ' +
                                  _fromDate.year.toString(),
                              style: Theme.of(context).textTheme.headline5,
                            ),

                          ),
                          Expanded(
                            child: Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).primaryColor,
                              size: 80,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 5,
                ),
                Expanded(child: InkWell(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    _showTimePicker();
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      height: 175,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 1)),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _fromTime.hour.toString() +
                                  ' : ' +
                                  _fromTime.minute.toString(),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          Expanded(
                            child: Icon(
                              Icons.access_time,
                              color: Theme.of(context).primaryColor,
                              size: 80,
                            ),
                          )
                        ],
                      )),
                )
                )
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
