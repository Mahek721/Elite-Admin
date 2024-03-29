import 'dart:convert';
import 'package:elite_admin_panel/API/api.dart';
import 'package:elite_admin_panel/Screen/userProfile.dart';
import 'package:elite_admin_panel/constantns/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class allUser extends StatefulWidget {
  const allUser({super.key});

  @override
  State<allUser> createState() => _allUserState();
}

class _allUserState extends State<allUser> {

  List<dynamic> userDetailList = [];
  bool _isLoading = false;

  getUser() async{
    setState(() {
      _isLoading = true;
    });
    var res = await http.post(Uri.parse(API.getUser));
    setState(() {
      userDetailList = jsonDecode(res.body);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users",
          style: TextStyle(fontWeight: FontWeight.w900),),
        actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch(userDetailList));
              },
            ),
          ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            for(int i=0;i<userDetailList.length;i++)
              InkWell(
                onTap: () {
                  Get.to(userDetail(uid: userDetailList[i]['uid'],));
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: userDetailList[i]['uimage']=="null"||userDetailList[i]['uimage']==null ? Icon(Icons.person,color: Colors.white,size: 40,) :  
                                      Image.network(API.hostUrl+"/user/"+userDetailList[i]['uimage'],fit: BoxFit.cover,),
                                    ),
                                  ),
                                  SizedBox(width: 14,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(userDetailList[i]['uname'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),),
                                      SizedBox(height: 4,),
                                      Text(userDetailList[i]['umono'],style: TextStyle(fontWeight: FontWeight.normal,fontSize: 13,),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded,color: n10,size: 16,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class DataSearch extends SearchDelegate<String> {
  final List<dynamic> userList;

  DataSearch(this.userList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  String get searchFieldLabel => 'Enter User Mobile No...';

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredData = userList
        .where((item) => item['umono'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.to(userDetail(uid: filteredData[index]['uid'],));
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: n12,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: filteredData[index]['uimage']=="null"||filteredData[index]['uimage']==null ? Icon(Icons.person,color: Colors.white,size: 40,) :  
                                Image.network(API.hostUrl+"/user/"+filteredData[index]['uimage'],fit: BoxFit.cover,),
                              ),
                            ),
                            SizedBox(width: 14,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(filteredData[index]['uname'],style: TextStyle(color: n10,fontWeight: FontWeight.bold,fontSize: 17,),),
                                SizedBox(height: 4,),
                                Text(filteredData[index]['umono'],style: TextStyle(color: nv60,fontWeight: FontWeight.w500,fontSize: 13,),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,color: n10,size: 16,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestedData = userList
        .where((item) => item['umono'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestedData.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.to(userDetail(uid: suggestedData[index]['uid'],));
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: n12,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: suggestedData[index]['uimage']=="null"||suggestedData[index]['uimage']==null ? Icon(Icons.person,color: Colors.white,size: 40,) :  
                                Image.network(API.hostUrl+"/user/"+suggestedData[index]['uimage'],fit: BoxFit.cover,),
                              ),
                            ),
                            SizedBox(width: 14,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(suggestedData[index]['uname'],style: TextStyle(color: n10,fontWeight: FontWeight.bold,fontSize: 17,),),
                                SizedBox(height: 4,),
                                Text(suggestedData[index]['umono'],style: TextStyle(color: nv60,fontWeight: FontWeight.w500,fontSize: 13,),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,color: n10,size: 16,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        );
        // ListTile(
        //   title: Text(suggestedData[index]['o_id']),
        //   onTap: () {
        //     Get.to(OrderDetailPage(orderid: suggestedData[index]['o_id']));
        //   },
        // );
      },
    );
  }
}