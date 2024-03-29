import 'dart:convert';
import 'dart:math';
import 'package:elite_admin_panel/API/api.dart';
import 'package:elite_admin_panel/Theme/theme_provider.dart';
import 'package:elite_admin_panel/constantns/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'order_detail.dart';

class userDetail extends StatefulWidget {
  String? uid;
  userDetail({this.uid,super.key});

  @override
  State<userDetail> createState() => _userDetailState();
}

class _userDetailState extends State<userDetail> {

  List<dynamic> userDetailList = [];
  List<dynamic> userOrderList = [];
  int countDeliver = 0;
  int countShip = 0;
  int countCancel = 0;
  bool _isLoading = false;
  Map<String, double> dataMap = {};

  List<dynamic> reviewList = [];

  reviewListLoad() async {
    var res = await http.post(Uri.parse(API.get_review), body: {'uid': widget.uid});
    setState(() {
      reviewList = jsonDecode(res.body);
    });
  }

  double r = 5.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    reviewListLoad();
  }

  getUser() async{
    setState(() {
      _isLoading = true;
    });
    var res = await http.post(Uri.parse(API.getUser),body: {'uid':widget.uid});
    setState(() {
      userDetailList = jsonDecode(res.body);
      getOrder();
    });
  }

  getOrder() async{
    print(widget.uid);
    var res = await http.post(Uri.parse(API.get_order),body: {'uid':widget.uid});
    setState(() {
      userOrderList = jsonDecode(res.body);
      countDeliver = userOrderList.where((item) => item['status'] == 'Deliver').length;
      dataMap["Deliver"] = double.parse(countDeliver.toString());
      countShip = userOrderList.where((item) => item['status'] == 'Ship').length;
      dataMap["Ship"] = double.parse(countShip.toString());
      countCancel = userOrderList.where((item) => item['status'] == 'Cancel').length;
      dataMap["Cancel"] = double.parse(countCancel.toString());
      _isLoading = false;
    });
  }

  getOrderItems(String id) async{
    List<dynamic>? orderItems;
    // setState(() {
    //   _isLoading = true;
    // });
    final response = await http.post(Uri.parse(API.get_order_item),body: {'o_id':id.toString()});

    if (response.statusCode == 200) {
      var records = jsonDecode(response.body);

      setState(() {
        orderItems = records;
        // _isLoading = false;
      });
    } else {
      print('Failed to load grouped records');
    }
    return orderItems;
  }

  String TimeConvert(String date) {
    int millisecondsSinceEpoch = int.parse(date);

    DateTime localTime =
    DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch, isUtc: true)
        .toLocal();

    int hour12 = localTime.hour % 12 == 0 ? 12 : localTime.hour % 12;

    String formattedLocalTime =
        '${localTime.year}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')} ${hour12.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}:${localTime.second.toString().padLeft(2, '0')} ${localTime.hour < 12 ? 'AM' : 'PM'}';

    return formattedLocalTime;
  }

  Toatalprice(List records){
    double total = 0;
    for(int i=0 ; i<records.length;i++){
      total += double.parse(records[i]["p_quantity"])*double.parse(records[i]["product_price"]);
    }
    return total.toString();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Detail",
          style: TextStyle(fontWeight: FontWeight.w800),),
      ),
      body: _isLoading ? Center(child: Container(
                        height: 55,
                        width: 55,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ),) : Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
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
                                child: userDetailList[0]['uimage']=="null"||userDetailList[0]['uimage']==null ? Icon(Icons.person,size: 40,) :  
                                Image.network(API.hostUrl+"/user/"+userDetailList[0]['uimage'],fit: BoxFit.cover,),
                              ),
                            ),
                            const SizedBox(width: 14,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(userDetailList[0]['uname'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,),),
                                const SizedBox(height: 4,),
                                Text(userDetailList[0]['umono'],style: TextStyle(color: nv60,fontWeight: FontWeight.w500,fontSize: 13,),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GradientCircleAvatar(
                              text: "Total Order\n${userOrderList.length}",
                              radius: 50,
                              gradientColors: const [Colors.grey, Colors.grey],
                            ),
                            GradientCircleAvatar(
                              text: "Deliver\n$countDeliver",
                              radius: 50,
                              gradientColors: const [Colors.grey, Colors.grey],
                            ),
                            
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GradientCircleAvatar(
                              text: "Ship\n$countShip",
                              radius: 50,
                              gradientColors: const [Colors.grey, Colors.grey],
                            ),
                            GradientCircleAvatar(
                              text: "Cancel\n$countCancel",
                              radius: 50,
                              gradientColors: const [Colors.grey, Colors.grey],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: 150,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 25,
                    centerText: "ORDER",
                    centerTextStyle: TextStyle(color: themeChange.darkTheme ? Colors.grey[200] : Colors.grey[800]),
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      // legendShape: _BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  ),
                ),
              ),
              ExpansionTile(
                title: Text("Orders",style: TextStyle(color: themeChange.darkTheme ? Colors.white : Colors.black,),),
                children: [
                  userOrderList.isEmpty ?

                  Center(child: Text("Orders not found"),)

                      :

                  Container(
                    height: userOrderList.length * 195.0,
                    width: double.infinity,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: userOrderList.length,
                      padding: const EdgeInsets.only(bottom: 10),
                      itemBuilder: (context, index) {
                        return FutureBuilder<dynamic>(
                            future: getOrderItems(userOrderList[index]["o_id"]),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data!
                                  .isEmpty) {
                                return Center(child: Container(),);
                              } else {
                                List<dynamic> list = snapshot.data!;
                                // Now you can use the 'list' to build your container.
                                return InkWell(
                                  onTap: () async{
                                    // var res = await Get.to(OrderDetailPage(
                                    //   orderid: userOrderList[index]["o_id"]
                                    //       .toString()));
                                  },
                                  child: Container(
                                    width: 100,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.transparent,
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                          offset: Offset(2, 2),
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, bottom: 8, right: 0, top: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                                                borderRadius: BorderRadius.circular(
                                                    15),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      for(int i = 0; i <
                                                          list.length; i++)
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: 50,
                                                              child: ClipRRect(
                                                                child: Image.network(
                                                                    API.hostUrl +
                                                                        "/admin/" +
                                                                        list[i]["product_image"],
                                                                    fit: BoxFit
                                                                        .fitWidth),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                          ],
                                                        ),
                                                      SizedBox(width: 15,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text("Order Time : " +
                                                        TimeConvert(
                                                            userOrderList[index]["o_id"]),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                      ),),
                                                    SizedBox(height: 4,),
                                                    Text("Order ID : " +
                                                        userOrderList[index]["o_id"],
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                      ),),
                                                    SizedBox(height: 4,),
                                                    Text("Total Items : " +
                                                        list.length.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                      ),),
                                                    SizedBox(height: 4,),
                                                    Row(
                                                      children: [
                                                        Text("Status: ",style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                        ),),
                                                        Text(
                                                          "${userOrderList[index]["status"]}",
                                                          style: TextStyle(
                                                            color: userOrderList[index]["status"] == "Cancel" ? Colors.red : Colors.black,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(50),
                                                      border: Border.all(
                                                          style: BorderStyle.solid),
                                                    ),
                                                    child: Center(child: Icon(Icons
                                                        .arrow_forward_ios_rounded,
                                                      size: 15,))),
                                              ],),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                        );
                      },
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text("Reviews",style: TextStyle(color: themeChange.darkTheme ? Colors.white : Colors.black,),),
                children: [
                  reviewList.isEmpty ?

                  Center(child: Text("Reviews not found"),)

                      :

                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for(int i=0;i<reviewList.length;i++)
                            Column(
                              children: [
                                MoreReviewCard(
                                  orderid: reviewList[i]["o_id"],
                                  image: API.hostUrl+"/admin/"+reviewList[i]["product_image"],
                                  name: reviewList[i]["product_name"],
                                  category: reviewList[i]["product_category"],
                                  price: double.parse(reviewList[i]["product_price"]),
                                  rating: double.parse(reviewList[i]["rating"]),
                                  rtitle: reviewList[i]["rtitle"],
                                  rdes : reviewList[i]["rdes"],
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientCircleAvatar extends StatelessWidget {
  final double radius;
  final List<Color> gradientColors;
  String text;

  GradientCircleAvatar({
    required this.radius,
    required this.text,
    required this.gradientColors,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MoreReviewCard extends StatelessWidget {
  final String image;
  final String name;
  final String category;
  String? rdes;
  String? rtitle;
  String? orderid;
  final double price;
  double? rating;
  void Function()? onTap;
  final Function(double)? onRatingChange;
  MoreReviewCard({
    super.key,
    this.orderid,this.onTap,this.onRatingChange,this.rdes=null,this.rtitle=null,this.rating,required this.image, required this.name, required this.category, required this.price,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order ID :- "+orderid!),
              Divider(),
              Row(
                children: [
                  Container(
                    height: min(140,MediaQuery.of(context).size.width * 0.20),
                    width: min(170,MediaQuery.of(context).size.width * 0.25),
                    child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(image, fit: BoxFit.fitHeight),
                    ),
                  ),
                  SizedBox(width: 18),
                  Expanded( // Wrap the Column in Expanded
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: n10, fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          category,
                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w400, fontSize: 13),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Expanded(
                                child: Text(
                                  "\₹ ${price}",
                                  maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: n10, fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                              ),
                            ),
                            if (rdes == null && rtitle == null)
                              Container()
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ReviewStar(
                                    rating: rating!,
                                    starColor: Colors.black,
                                    starSize: min(40,MediaQuery.of(context).size.width * 0.05),
                                    onRatingChanged: onRatingChange,
                                  )
                                ],
                              ),
                          ],
                        ),
                        if (rdes == null && rtitle == null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.error_outline_rounded,color: Colors.red,size: 18,),
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      " Review This Products",
                                      style: TextStyle(color: Colors.red,fontSize: 12,),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else
                          Container()
                      ],
                    ),
                  ),
                ],
              ),
              if (rdes == null && rtitle == null)
                Container()
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    Text(
                      "Your Review",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Text(
                          "❝",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 10),
                        Text(
                          rtitle!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 30),
                        Text(
                          "❝",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            rdes!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),

    );
  }
}

class ReviewStar extends StatefulWidget {
  final double starSize;
  double rating;
  final Color starColor;
  final Color emptyStarColor;
  final Function(double)? onRatingChanged;

  ReviewStar({
    this.rating = 5.0,
    this.starSize = 24.0,
    this.starColor = Colors.amber,
    this.emptyStarColor = Colors.grey,
    this.onRatingChanged,
  });

  @override
  _ReviewStarState createState() => _ReviewStarState();
}

class _ReviewStarState extends State<ReviewStar> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        double starValue = index + 1.0;
        IconData iconData = Icons.star;

        return GestureDetector(
          onTap: () {
            setState(() {
              widget.rating = starValue;
              widget.onRatingChanged!(widget.rating);
            });
          },
          child: Icon(
            iconData,
            size: widget.starSize,
            color: starValue <= widget.rating ? widget.starColor : widget.emptyStarColor,
          ),
        );
      }),
    );
  }
}