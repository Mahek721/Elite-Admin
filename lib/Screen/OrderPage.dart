import 'dart:convert';
import 'package:elite_admin_panel/API/api.dart';
import 'package:elite_admin_panel/Screen/order_detail.dart';
import 'package:elite_admin_panel/Theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<dynamic>? orderDetails;
  String selectedValue = 'All';
  @override
  void initState() {
    super.initState();
    fetchGroupedRecords(selectedValue);
  }

  bool _isLoading = false;

  getOrderItems(String id) async{
    List<dynamic>? orderItems;
    // setState(() {
    //   _isLoading = true;
    // });
    final response = await http.post(Uri.parse(API.get_order_item),body: {'o_id':id.toString()});

    if (response.statusCode == 200) {
      var records = jsonDecode(response.body);

      // setState(() {
        orderItems = records;
        // _isLoading = false;
      // });
    } else {
      print('Failed to load grouped records');
    }
    return orderItems;
  }


  Future<void> fetchGroupedRecords(String status) async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(Uri.parse(API.get_order),body: {'status' : status});

    if (response.statusCode == 200) {
      var records = jsonDecode(response.body);

      setState(() {
        orderDetails = records;
        _isLoading = false;
      });
    } else {
      print('Failed to load grouped records');
    }
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
    try {
      return Scaffold(
        appBar: AppBar(
          title: Text("Orders",
            style: TextStyle(fontWeight: FontWeight.bold),),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement search functionality here
                showSearch(context: context,
                 delegate: DataSearch(orderDetails!));
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: Container(
                        height: 55,
                        width: 55,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ),)
            : SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(              
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                            fetchGroupedRecords(selectedValue);
                        },
                        items: [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('All'),
                          ),
                          DropdownMenuItem(
                            value: 'Confirmed',
                            child: Text('Confirmed'),
                          ),
                          DropdownMenuItem(
                            value: 'Ship',
                            child: Text('Ship'),
                          ),
                          DropdownMenuItem(
                            value: 'Cancel',
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              orderDetails!.isEmpty ? selectedValue=="All" ? Expanded(child: Center(child: Text("Not Order Place Anything"),)) : Expanded(child: Center(child: Text("Not Order $selectedValue Anything"),)) : Expanded(
                child: ListView.builder(
                  itemCount: orderDetails?.length ?? 0,
                  padding: const EdgeInsets.only(bottom: 10),
                  itemBuilder: (context, index) {
                    return FutureBuilder<dynamic>(
                        future: getOrderItems(orderDetails![index]["o_id"]),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!
                              .isEmpty) {
                            return Center(child: Container(),);
                          } else {
                            List<dynamic> list = snapshot.data!;
                            // Now you can use the 'list' to build your container.
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15,),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[600]!,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      for(int i = 0; i < list.length; i++)
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 50,
                                                child: ClipRRect(
                                                  child: Image
                                                      .network(
                                                      API.hostUrl +
                                                          "/admin/" +
                                                          list[i]["product_image"],
                                                      fit: BoxFit
                                                          .fitWidth),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      // Divider(color: Colors.grey,),
                                      OrderCard(
                                        status: orderDetails![index]["status"], 
                                        date: TimeConvert(orderDetails![index]["o_id"]), 
                                        orderId: orderDetails![index]["o_id"], 
                                        quantity: list.length, 
                                        totalPrice: 1999.00, 
                                        onTap: () async{ var res = await Get.to(OrderDetailPage(
                                          orderid: orderDetails![index]["o_id"]
                                              .toString()));
                                          if(res == true){
                                            fetchGroupedRecords(selectedValue);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    }catch(e){
      return Container();
    }
  }
}

class OrderCard extends StatelessWidget {
  final String status;
  final String date;
  final String orderId;
  final int quantity;
  final double totalPrice;
  void Function()? onTap;
  OrderCard({super.key, required this.status, required this.date, required this.orderId, required this.quantity, required this.totalPrice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.clock),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(status,style: TextStyle(fontWeight: FontWeight.bold,color: status == "Cancel" ? Colors.red : Colors.green),),
                        SizedBox(height: 5,),
                        Text(date,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                      ],
                    ),
                  ],
                ),
                Icon(CupertinoIcons.chevron_forward),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.bag),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("OrderId",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,fontSize: 10,),),
                        SizedBox(height: 5,),
                        Text(orderId,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,),),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CupertinoIcons.cube_box),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Products",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,fontSize: 10,),),
                        SizedBox(height: 5,),
                        Text("${quantity}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class DataSearch extends SearchDelegate<String> {
  final List<dynamic> orderDetails;

  DataSearch(this.orderDetails);

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
  String get searchFieldLabel => 'Enter order id...';

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  Future<List<dynamic>> getOrderItems(String id) async {
    List<dynamic>? orderItems;

    final response = await http.post(Uri.parse(API.get_order_item), body: {'o_id': id.toString()});

    if (response.statusCode == 200) {
      var records = jsonDecode(response.body);
      orderItems = records;
    } else {
      print('Failed to load grouped records');
    }

    return orderItems ?? [];
  }


  @override
  Widget buildResults(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    final filteredData = orderDetails
        .where((item) => item['o_id'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        return FutureBuilder<dynamic>(
            future: getOrderItems(orderDetails[index]["o_id"]),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!
                  .isEmpty) {
                return Center(child: Container(),);
              } else {
                List<dynamic> list = snapshot.data!;
                // Now you can use the 'list' to build your container.
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10,),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0, bottom: 8, right: 0, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            for(int i = 0; i < list.length; i++)
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 50,
                                      child: ClipRRect(
                                        child: Image
                                            .network(
                                            API.hostUrl +
                                                "/admin/" +
                                                list[i]["product_image"],
                                            fit: BoxFit
                                                .fitWidth),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            // Divider(color: Colors.grey,),
                            OrderCard(
                              status: orderDetails[index]["status"], 
                              date: _OrderPageState().TimeConvert(orderDetails[index]["o_id"]), 
                              orderId: orderDetails[index]["o_id"], 
                              quantity: list.length, 
                              totalPrice: 1999.00, 
                              onTap: () async{ 
                                Get.to(OrderDetailPage(
                                  orderid: orderDetails[index]["o_id"]
                                      .toString()));
                              },
                            ),
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    final suggestedData = orderDetails
        .where((item) => item['o_id'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestedData.length,
      itemBuilder: (context, index) {
        return FutureBuilder<dynamic>(
                future: getOrderItems(orderDetails[index]["o_id"]),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!
                      .isEmpty) {
                    return Center(child: Container(),);
                  } else {
                    List<dynamic> list = snapshot.data!;
                    // Now you can use the 'list' to build your container.
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10,),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                          ),
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
                                for(int i = 0; i < list.length; i++)
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 50,
                                      child: ClipRRect(
                                        child: Image
                                            .network(
                                            API.hostUrl +
                                                "/admin/" +
                                                list[i]["product_image"],
                                            fit: BoxFit
                                                .fitWidth),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            // Divider(color: Colors.grey,),
                            OrderCard(
                              status: orderDetails[index]["status"], 
                              date: _OrderPageState().TimeConvert(orderDetails[index]["o_id"]), 
                              orderId: orderDetails[index]["o_id"], 
                              quantity: list.length, 
                              totalPrice: 1999.00, 
                              onTap: () async{ 
                                Get.to(OrderDetailPage(
                                  orderid: orderDetails[index]["o_id"]
                                      .toString()));
                              },
                            ),
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
    );
  }
}
