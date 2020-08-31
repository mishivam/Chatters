// import 'package:chatters/modal/constants.dart';
// import 'package:chatters/services/sharedPreferenceFunction.dart';
// import 'package:chatters/view/chatScreen.dart';
import 'package:chatters/modal/constants.dart';
import 'package:chatters/modal/fadeInAnimation.dart';
import 'package:chatters/view/search.dart';
// import 'package:chatters/view/searchHistory.dart';
// import 'package:chatters/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chatters/services/database.dart';
import 'package:gradient_text/gradient_text.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchUser = TextEditingController();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  var searchedUsers = [];
  var searchHistory = [];
  var deleteHistory = [];
  var deleteOldHistory = [];
  Gradient _gradient = LinearGradient(colors: [
    Color(0xffff5f6d),
    Color(0xffff5f6d),
    Color(0xffffc371),
  ]);
  final String currentUserName = Constants.myName;
  Stream searchHistorySnapshot;

  _request() async {
    setState(() {
      getHistory();
    });
  }

  shouldRefresh() {
    setState(() {
      SearchScreen();
    });
  }

  getHistory() async {
    await dataBaseMethods.getSearchHistory(currentUserName).then((value) {
      setState(() {
        searchHistorySnapshot = value;
      });
    });
  }

  Widget history() {
    return StreamBuilder(
      stream: searchHistorySnapshot,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? GridView.builder(
                itemCount: snapshot.data.documents.length,
                padding: EdgeInsets.only(left: 10, right: 10.0),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemBuilder: (context, index) {
                  return ShowHistory(snapshot.data.documents[index],
                      snapshot.data.documents.length);
                })
            : Container(
                child: Column(
                children: [
                  Center(
                      child: Text(
                    "Pleas Wait Loading..",
                    style: TextStyle(color: Colors.white),
                  )),
                  Container(child: Center(child: CircularProgressIndicator()))
                ],
              ));
      },
    );
  }

  // getSearchHistory() async {
  //   await dataBaseMethods.getSearchHistory(currentUserName).then((value) {
  //     if (value != null) {
  //       for (int i = 0; i < value.documents.length; i++) {
  //         if (i < 4) {
  //           setState(() {
  //             searchHistory.add(value.documents[i].data);
  //           });
  //         }
  //         if (i >= 4) {
  //           setState(() {
  //             deleteOldHistory.add(value.documents[i].data);
  //           });
  //         }
  //       }
  //     }
  //   });
  //   if (searchHistory.isNotEmpty) {
  //     print('searchHistory length : ${searchHistory[0]['searchName']}');
  //     for (int i = 0; i < searchHistory.length; i++) {
  //       await dataBaseMethods
  //           .getUserByUserName(searchHistory[i]['searchName'])
  //           .then((val) {
  //         setState(() {
  //           searchedUsers.add(val);
  //         });
  //       });
  //     }
  //   }
  //   if (deleteOldHistory.isNotEmpty) {
  //     for (int i = 0; i < deleteOldHistory.length; i++) {
  //       await dataBaseMethods.deleteUserFromDatabase(
  //           currentUserName, deleteOldHistory[i]['searchName']);
  //     }
  //   } else {
  //     print('nothing to delete');
  //   }
  // }

  @override
  void initState() {
    _request();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              onTap: () async {
                await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              },
              controller: searchUser,
              showCursor: false,
              readOnly: true,
              keyboardAppearance: null,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade100)),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GradientText(
            "Recent Searches",
            gradient: _gradient,
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 15,
          ),
          history(),
        ],
      ),
    );
  }
}

class ShowHistory extends StatefulWidget {
  final dynamic historySnapshot;
  final int snapshotLength;
  ShowHistory(this.historySnapshot, this.snapshotLength);

  @override
  _ShowHistoryState createState() => _ShowHistoryState();
}

class _ShowHistoryState extends State<ShowHistory> {
  var searchedUsers = [];
  var searchHistory = [];
  var deleteHistory = [];
  var deleteOldHistory = [];
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  final String currentUserName = Constants.myName;

  getSearchedUserInfo() async {
    print("getSearchedUSerInfo : ${widget.historySnapshot.data['searchName']}");
    try {
      await dataBaseMethods
          .getUserByUserName(widget.historySnapshot.data['searchName'])
          .then((val) {
        for (int i = 0; i < widget.snapshotLength; i++) {
          if (i < 4) {
            setState(() {
              searchedUsers.add(val);
            });
          } else {
            print('adding to deleteHistory');
            setState(() {
              deleteHistory.add(val);
            });
          }
        }
      });
      if (deleteHistory.isNotEmpty) {
        print("deleteHistory :" + deleteHistory.length.toString());

        for (int i = 0; i < deleteHistory.length; i++) {
          print('deletedUser: ' + deleteHistory[i].documents[0].data['name']);
          await dataBaseMethods.deleteUserFromDatabase(
              currentUserName, deleteHistory[i].documents[0].data['name']);
        }
      } else {
        print('nothing to delete');
      }
    } catch (e) {
      print('from getSearchedUserInfo :' + e.toString());
    }
  }

  buildHistoryCard(element) {
    try {
      if (element.documents.length != 0) {
        for (int i = 0; i < element.documents.length; i++) {
          return GestureDetector(
            // onTap:()=>createChatRoomAndStartConversation(data['name']),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 2.0,
                color: Colors.purple,
                child: Column(children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: Icon(Icons.close, color: Colors.grey.shade900),
                        onPressed: () async {
                          await dataBaseMethods.deleteUserFromDatabase(
                              currentUserName,
                              element.documents[0].data['name']);
                          if (mounted) {
                            setState(() {});
                          }
                        }),
                  ),
                  Text(element.documents[i].data['name'],
                      style:
                          TextStyle(color: Colors.grey.shade100, fontSize: 20)),
                  SizedBox(
                    height: 25,
                  ),
                  Text(element.documents[i].data['email'],
                      style:
                          TextStyle(color: Colors.grey.shade100, fontSize: 20))
                ])),
          );
        }
        print("buildHistoryCard length of e :" +
            element.documents[0].data.toString());
      }
    } catch (e) {
      print("from buildHistoryCard from searchScreen :" + e.toString());
    }
  }

  @override
  void initState() {
    getSearchedUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return searchedUsers.length != 0
        ? Stack(
            children: searchedUsers
                .map((e) => FadeIn(0.1, buildHistoryCard(e)))
                .toList())
        : Container(
            child: Column(
            children: [
              Center(
                  child: Text(
                "Pleas Wait Loading..",
                style: TextStyle(color: Colors.white),
              )),
              Container(child: Center(child: CircularProgressIndicator()))
            ],
          ));
  }
}
