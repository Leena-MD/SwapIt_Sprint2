import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_swap/models/goods.dart';
import 'package:first_swap/provider/my_provider.dart';
import 'package:first_swap/src/pages/Search.dart';
import 'package:first_swap/src/widgets/bottom_Container.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_swap/fluttericon.dart';
import 'package:first_swap/src/pages/bags.dart';
import 'package:first_swap/src/pages/books_category.dart';
import 'package:first_swap/src/pages/clothes.dart';
import 'package:first_swap/src/pages/computer_category.dart';
import 'package:first_swap/src/pages/gym.dart';
import 'package:first_swap/src/pages/perfume.dart';
import 'package:first_swap/src/pages/pet.dart';
import 'package:first_swap/src/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:first_swap/fluttericon.dart';
import 'package:first_swap/src/widgets/app_outlinebutton.dart';
import 'package:first_swap/src/widgets/app_textfield.dart';
import 'package:first_swap/themes.dart';
import 'package:provider/provider.dart';
import 'Intrests_page.dart';
import 'Post_page.dart';
import 'MyItems.dart';
import 'Offers.dart';
import 'Search.dart' as eos;
import 'package:firebase_database/firebase_database.dart';
import 'details_page.dart';
import 'house.dart';
import 'kids_category.dart';
import 'clothes.dart';
import 'gym.dart';
import 'bags.dart';
import 'pet.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlayStyle, rootBundle;

import 'package:csv/csv.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

int rel = 1;
int doi = 0;
int enter = 1;
String v0 = "";
String v1 = "";
String v2 = "";
String ok = "";
var dn;
List<List> data = List<List<dynamic>>.empty(growable: true);
List<List> data2 = List<List<dynamic>>.empty(growable: true);
//user's response will be assigned to this variable
String final_response = "";
String final_response2 = "";
List<dynamic> userRecomendation = [];
List<dynamic> userSimilarity = [];
String cat1 = "";
String cat2 = "";
String cat3 = "";
String cat4 = "";
String cat5 = "";
String cat6 = "";
String cat7 = "";
String cat8 = "";
String eId = "";
List<Product> top1 = [];
List<Product> top2 = [];
List<Product> top3 = [];

List<Product> cold = [];

int reload = 0;

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    saveTokenToDatabase();

    loadAsset();

    super.initState();
  }

  loadAsset() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          //.then((value) => null)
          .then((ds) {
        eId = ds.data()!['uid'];
      }).catchError((e) {
        print(e);
      });
    }
    print(eId);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('goods')
        .where(
          "owner",
          isEqualTo: eId,
        )
        .where(
          "Status",
          isEqualTo: 'done',
        )
        .get();

    print(querySnapshot.size);
    if (querySnapshot.size != 0) {
      final User? user2 = eos.auth.currentUser;
      final uid2 = user2!.uid;
      String name = eos.uid;

      final url = 'http://swappython.azurewebsites.net/name';

      //sending a post request to the url
      final response =
          await http.post(Uri.parse(url), body: json.encode({'name': uid2}));
      final response2 = await http.get(Uri.parse(url));

      //converting the fetched data from json to key value pair that can be displayed on the screen
      final decoded = json.decode(response2.body) as Map<String, dynamic>;

      //changing the UI be reassigning the fetched data to final response
      if (mounted)
        setState(() {
          final_response = decoded['name'];
        });
      print(final_response + "-" + final_response);
    } else {
      print("no swaps found");
      doi = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget");
    print(top1.length);
    if (enter == 1) {
      if (rel == 1) {
        //rel = 0;
        print("if");
        MyProvider provider = Provider.of<MyProvider>(context);
        provider.getTop1List();
        top1 = provider.Top1list;
        provider.cold();
        print('yes');
        print(top1);
        print("yes2");
        reload = 0;
        if (top1.isNotEmpty) {
          rel = 0;
          enter = 0;
        }
        print("this is doi");
        print(doi);
        if (top1.isEmpty && doi == 1) {
          print("ll");
          print(doi);
          enter = 0;
          cold = provider.coldlistt;
        } else {
          cold = [];
        }
        //rel = 2;
      } else {
        // rel = 1;
      }
    }
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CustomBottomNavigationBar(
          iconList: [
            Icons.home,
            Icons.add_to_photos,
            Icons.add_a_photo,
            Icons.reorder_rounded,
            Icons.person,
          ],
          onChange: (val) {
            if (mounted)
              setState(() {
                var _selectedItem = val;
              });
          },
          defaultSelectedIndex: 0,
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 23,
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(30, 30),
                            bottomRight: Radius.elliptical(30, 30),
                          ),
                          color: Colors.cyan[800],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Spacer(),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(letterSpacing: 1.3),
                                children: [
                                  TextSpan(
                                    text: "بــــــدّل",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 9,
                            ),
                            Text(
                              "قديم عندك جديد عند غيرك",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1.3,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 20,
                      right: 20,
                      child: Container(
                        height: 57,
                        alignment: Alignment.center,
                        child: Center(
                          child: TextField(
                            onTap: () {
                              Navigator.push(
                                  this.context,
                                  MaterialPageRoute(
                                      builder: (context) => searchPage()));
                            },
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide.none),
                              hintText: "البحث",
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text("الفئات   ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19)),
                      SizedBox(height: 20),
                      CategoryContainer(),
                      SizedBox(
                        height: 1,
                      ),
                      Divider(),
                      SizedBox(
                        height: 1,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, '/details');
                        },
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Spacer(),
                                  Text(
                                    "قد يعجبك أيضاً",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Container(
                                height: 300,
                                child: ListView.builder(
                                  itemCount: 1,
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  itemBuilder: (context, id) {
                                    return Container(
                                      width: 350,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 15.0),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            height: 350,
                                            child: top1.isEmpty
                                                ? GridView.count(
                                                    shrinkWrap: false,
                                                    primary: false,
                                                    crossAxisCount: 1,
                                                    reverse: true,
                                                    childAspectRatio: 0.9,
                                                    crossAxisSpacing: 16,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: cold
                                                        .map(
                                                          (e) =>
                                                              BottomContainer(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DetailPage(
                                                                    image:
                                                                        e.image,
                                                                    name:
                                                                        e.title,
                                                                    description:
                                                                        e.description,
                                                                    cate:
                                                                        e.cate,
                                                                    owner:
                                                                        e.owner,
                                                                    IDgoods: e
                                                                        .IDgoods,
                                                                    ownerRate: e
                                                                        .ownerRate,
                                                                    ownerName: e
                                                                        .ownerName,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            image: e.image,
                                                            name: e.title,
                                                          ),
                                                        )
                                                        .toList())
                                                : GridView.count(
                                                    shrinkWrap: false,
                                                    primary: false,
                                                    reverse: true,
                                                    crossAxisCount: 1,
                                                    childAspectRatio: 0.9,
                                                    crossAxisSpacing: 16,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: top1
                                                        .map(
                                                          (e) =>
                                                              BottomContainer(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DetailPage(
                                                                    image:
                                                                        e.image,
                                                                    name:
                                                                        e.title,
                                                                    description:
                                                                        e.description,
                                                                    cate:
                                                                        e.cate,
                                                                    owner:
                                                                        e.owner,
                                                                    IDgoods: e
                                                                        .IDgoods,
                                                                    ownerRate: e
                                                                        .ownerRate,
                                                                    ownerName: e
                                                                        .ownerName,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            image: e.image,
                                                            name: e.title,
                                                          ),
                                                        )
                                                        .toList()),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//when user is logged in we save token in firestore for using it to send notification
void saveTokenToDatabase() async {
  String? token = await FirebaseMessaging.instance.getToken();
  // Assume user is logged in for this example
  String userId = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'token': token,
  });
}

class CategoryContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: SizedBox(
          height: 120.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            children: <Widget>[
              Container(
                width: 120,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => BooksCat())),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/bookshelf.png",
                        width: 50,
                      ),
                      SizedBox(height: 15),
                      Text("المستلزمات المكتبية و الكتب",
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              Container(
                width: 120,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ComputerCat())),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/computer.png",
                        width: 50,
                      ),
                      SizedBox(height: 15),
                      Text("الأجهزة الالكترونية و ملحقاتها",
                          textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              Container(
                width: 120,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => houseK())),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/kitchen.png",
                        width: 50,
                      ),
                      SizedBox(height: 15),
                      Text("المنزل و المطبخ", textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              Container(
                width: 120,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => clothes())),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/clothes-rack.png",
                        width: 50,
                      ),
                      SizedBox(height: 15),
                      Text("الملابس", textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              Container(
                width: 120,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => KidsCat())),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/brick.png",
                        width: 50,
                      ),
                      SizedBox(height: 15),
                      Text("منتجات الأطفال و الألعاب",
                          textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              Container(
                width: 120,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => gym())),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/dumbbell.png",
                        width: 50,
                      ),
                      SizedBox(height: 15),
                      Text("الرياضة و اللياقة", textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              Container(
                width: 120,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => bags())),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/handbag.png",
                        width: 50,
                      ),
                      SizedBox(height: 15),
                      Text("الاكسسوارات و الحقائب و الأحذية",
                          textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              Container(
                width: 120,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => perfume())),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/make-up.png",
                        width: 50,
                      ),
                      SizedBox(height: 15),
                      Text("الجمال و العطور", textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              Container(
                width: 120,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => pet())),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/pet-house.png",
                        width: 50,
                      ),
                      SizedBox(height: 15),
                      Text("مستلزمات الحيوان", textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DealsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/details');
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "..المزيد",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15),
                  ),
                  onPressed: () {},
                ),
                Spacer(),
                Text(
                  "قد يعجبك ايضاً",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
              ],
            ),
            SizedBox(
              height: 9,
            ),
            Container(
              height: 150,
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemBuilder: (context, id) {
                  return SingleItem();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


class SingleItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 205,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 3.0),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            height: 510,
            child: top1.isEmpty
                ? Text(
                    " لا يوجد منتجات لهذه الفئة",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  )
                : GridView.count(
                    shrinkWrap: false,
                    primary: false,
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 10,
                    children: top1
                        .map(
                          (e) => BottomContainer(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    image: e.image,
                                    name: e.title,
                                    description: e.description,
                                    cate: e.cate,
                                    owner: e.owner,
                                    IDgoods: e.IDgoods,
                                    ownerRate: e.ownerRate,
                                    ownerName: e.ownerName,
                                  ),
                                ),
                              );
                            },
                            image: e.image,
                            name: e.title,
                          ),
                        )
                        .toList()),
          )
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
      required this.iconList,
      required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i));
    }

    return Row(
      children: _navBarItemList,
 );
 }

 Widget buildNavBarItem(IconData icon, int index) {
 return GestureDetector(
 onTap: () {
 widget.onChange(index);

 setState(() {
 _selectedIndex = index;
 if (_selectedIndex == 0)
 Navigator.push(this.context,
 MaterialPageRoute(builder: (context) => HomePage()));
 if (_selectedIndex == 1)
 Navigator.push(this.context,
 MaterialPageRoute(builder: (context) => MyItems()));
 if (_selectedIndex == 2)
 Navigator.push(this.context,
 MaterialPageRoute(builder: (context) => PostPage()));

 if (_selectedIndex == 3)
 Navigator.push(this.context,
 MaterialPageRoute(builder: (context) => Offers()));
 if (_selectedIndex == 4)
 Navigator.push(this.context,
 MaterialPageRoute(builder: (context) => ProfilePage()));
 });
 },
 child: Container(
 height: 60,
 width: MediaQuery.of(this.context).size.width / _iconList.length,
 decoration: index == _selectedIndex
 ? BoxDecoration(
 border: Border(
 bottom: BorderSide(width: 4, color: Colors.blueGrey),
 ),
 gradient: LinearGradient(colors: [
 Colors.blueGrey.withOpacity(0.3),
 Colors.blueGrey.withOpacity(0.015),
 ], begin: Alignment.bottomCenter, end: Alignment.topCenter)

 //color: index == _selectedItemIndex ? Colors.green : Colors.white,

 )
 : BoxDecoration(),
 child: Column(
 children: <Widget>[
 Icon(
 icon,
 color: index == _selectedIndex ? Colors.black : Colors.grey,
 ),
 if (index == 0) Text('الرئيسية'),
 if (index == 1) Text('منتجاتي'),
 if (index == 2) Text('اضافة'),
 if (index == 3) Text('الطلبات'),
 if (index == 4) Text('حسابي'),
 ],
 ),
 ),
 );
 }
}