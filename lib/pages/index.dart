import 'dart:ffi';
import 'dart:io';

import 'package:abc/pages/ContactDataModel.dart';
import 'package:abc/theme/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:ui';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<IndexPage> {
  List _items = [];
  Future<List<ContactDataModel>> ReadJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString("jsonfile/user.json");
    final list = jsonDecode(jsondata) as List<dynamic>;

    return list.map((e) => ContactDataModel.fromJson(e)).toList();
  }

  Future<void> share(List<ContactDataModel> contact, int index) async {
    await FlutterShare.share(
      title: contact[index].name.toString(),
      text: contact[index].name.toString() +
          '\n Phone:' +
          contact[index].phone.toString() +
          '\n Last Checkin:' +
          contact[index].checkin.toString(),
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("End"),
          content: Text("You have reached end of the list"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            )
          ],
        ),
      );

  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    // Setup the listener.
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          openDialog();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ContactDataModel contact = new ContactDataModel();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          title: Text("Contact List"),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return ReadJsonData();
          },
          child: FutureBuilder(
              future: ReadJsonData(),
              builder: (context, data) {
                if (data.hasError) {
                  return Center(child: Text("${data.error}"));
                } else if (data.hasData) {
                  var items = data.data as List<ContactDataModel>;
                  ContactDataModel contact = new ContactDataModel();
                  return ListView.builder(
                    controller: _controller,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "https://cdn4.iconfinder.com/data/icons/web-app-flat-circular-icons-set/64/Iconos_Redondos_Flat_Usuario_Icn-512.png"))),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 15, 0, 5),
                                  child: Text(
                                    items[index].name.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 5),
                                  child: Text(
                                    items[index].phone.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[900],
                                        fontFeatures: <FontFeature>[
                                          FontFeature.tabularFigures(),
                                        ]),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 5),
                                  child: Text(
                                    items[index].checkin.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[900],
                                        fontFeatures: <FontFeature>[
                                          FontFeature.tabularFigures(),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  alignment: Alignment.centerRight,
                                  color: primary,
                                  icon: Icon(Icons.share_outlined),
                                  onPressed: () {
                                    share(items, index);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: items.length,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }
}
