import 'dart:convert';
import 'package:elite_admin_panel/API/api.dart';
import 'package:elite_admin_panel/Screen/userProfile.dart';
import 'package:elite_admin_panel/Theme/theme_provider.dart';
import 'package:elite_admin_panel/constantns/constants.dart';
import 'package:elite_admin_panel/screen/paymentData.dart';
import 'package:elite_admin_panel/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatefulWidget {
  final String? orderid;
  OrderDetailPage({this.orderid, Key? key}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>{

  final reason = TextEditingController();


  List<dynamic> orderDetails = [];
  List<dynamic> paymentData = [];

  Future<void> getOrderDetail() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(Uri.parse(API.get_order),body: {'oid':widget.orderid});

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

  paymentDataLoad() async{
    var res = await http.post(Uri.parse(API.getPayment),body: {'o_id':widget.orderid});
    setState(() {
      paymentData = jsonDecode(res.body);
      print(paymentData);
    });
  }


  String TimeConvert(String date) {
    int millisecondsSinceEpoch = int.parse(date);

    DateTime localTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch, isUtc: true)
            .toLocal();


    String formattedLocalTime =
        '${localTime.year}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')}';

    return formattedLocalTime;
  }

  Product_MRP(List<dynamic> r){
    int total = 0;

    for(int i=0;i<r.length;i++){
      total += (int.parse(r[i]["product_mrp"]) * int.parse(r[i]["p_quantity"]));
    }
    return total.toString();
  }

  totalPayable(List<dynamic> r,Map<String,dynamic> r1){
    int total = 0;

    for(int i=0;i<r.length;i++){
      total += (int.parse(r[i]["product_price"]) * int.parse(r[i]["p_quantity"]));
    }
    total = total - int.parse(r1["total_discounts"]);
    return total.toString();
  }

  Product_Price(List<dynamic> r){
    int total = 0;

    for(int i=0;i<r.length;i++){
      total += (int.parse(r[i]["product_price"]) * int.parse(r[i]["p_quantity"]));
    }
    return total.toString();
  }

  List<dynamic>? orderItems;
  bool _isLoading = false;

  getOrderItems() async{
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(Uri.parse(API.get_order_item),body: {'o_id':widget.orderid});

      if (response.statusCode == 200) {
        var records = jsonDecode(response.body);

        setState(() {
          orderItems = records;
          _isLoading = false;
        });
      } else {
        print('Failed to load grouped records');
      }
  }

  totalSave(Map<String,dynamic> r,List<dynamic> r1){
    int total = 0;

    for(int i=0;i<r1.length;i++){
      total += (int.parse(r1[i]["product_mrp"]) * int.parse(r1[i]["p_quantity"])) - (int.parse(r1[i]["product_price"]) * int.parse(r1[i]["p_quantity"]));
    }
    total += int.parse(r["total_discounts"]);
    return total.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderItems();
    getOrderDetail();
    paymentDataLoad();
  }

  final tname = TextEditingController();
  final tnumber = TextEditingController();
  final tlink = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  dialogBottom() async{
    var res = await Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 350,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12),),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text("Tracking Detail",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                  SizedBox(height: 10),
                  Text_Form_Field(
                    controller: tname,
                    hintText: "Courier Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a courier name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text_Form_Field(
                    controller: tnumber,
                    hintText: "Tracking Number",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a tracking number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text_Form_Field(
                    controller: tlink,
                    hintText: "Tracking Link",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a tracking link';
                      }
                      final RegExp urlRegExp = RegExp(
                        r'^(?:http|https):\/\/[\w\-_]+(?:\.[\w\-_]+)+(?:[\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$',
                      );
                      if (!urlRegExp.hasMatch(value)) {
                        return 'Please enter a valid tracking link';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // ElevatedButton(
                  //   onPressed: () {
                      
                  //   },
                  //   child: Text("Update Tracking"),
                  // )
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _submitForm();
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text("Update Tracking",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      enableDrag: true,
    );
    setState(() {
      print(res);
      if(res==null){
        getOrderItems();
        getOrderDetail();
        paymentDataLoad();
      }
    });
  }

  void _submitForm() async {
    var res = await http.post(Uri.parse(API.getShip),body: {'oid':widget.orderid.toString()});
    setState(() {
      List<dynamic> response = jsonDecode(res.body);
      if(response.isEmpty){
        inserTracking();
      }else{
        updateTracking();
      }
    });
  }

  inserTracking() async{
    var res = await http.post(Uri.parse(API.insert_ship), body: {
            'tname': tname.text.toString(),
            'tnumber': tnumber.text.toString(),
            'tlink': tlink.text.toString(),
            'oid': widget.orderid.toString(),
            'time': DateTime.now().millisecondsSinceEpoch.toString(),
          });
    setState(() {
      print("insert ${res.body}");
      Get.back();
    });
  }

  updateTracking() async{
    var res = await http.post(Uri.parse(API.update_ship), body: {
            'tname': tname.text.toString(),
            'tnumber': tnumber.text.toString(),
            'tlink': tlink.text.toString(),
            'oid': widget.orderid.toString(),
            'time': DateTime.now().millisecondsSinceEpoch.toString(),
          });
    setState(() {
      print("update ${res.body}");
      Get.back();
    });
  }


  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    try {
      return WillPopScope(
        onWillPop: () async {
          Get.back(result: true);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Order Detail",
              style: TextStyle(fontWeight: FontWeight.w900),),
            actions: [
              PopupMenuButton(
                icon: Icon(Icons.more_vert), // Icon for overflow menu
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: Text('Payment Data Info.'),
                    value: 'd1',
                  ),
                  PopupMenuItem(
                    child: Text('User Detail'),
                    value: 'd2',
                  ),
                ],
                onSelected: (value) {
                  // Add logic based on the selected option
                  switch (value) {
                    case 'd1':
                      Get.to(PaymentDataInfo(data: paymentData,));
                      break;
                    case 'd2':
                      Get.to(userDetail(uid:orderDetails[0]["uid"]));
                      break;
                  }
                },
              ),
            ],
          ),
          bottomNavigationBar: Container(
            width: double.infinity,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15,right: 15,left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          orderDetails[0]["status"] == "Cancel" ?
                          Get.dialog(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Material(
                                        child: Column(
                                          children: [
                                            const Icon(Icons.info_outline),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "Are you sure?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 15),
                                            const Text(
                                              "This order already has been cancelled. You want to re-ship this order.",
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 20),
                                            //Buttons
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    child: const Text(
                                                      'NO',
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      foregroundColor: Colors.white, backgroundColor: Colors.black, minimumSize: const Size(0, 45),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    onPressed: () {Get.back();},
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    child: const Text(
                                                      'YES',
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      foregroundColor: Colors.white, backgroundColor: Colors.black, minimumSize: const Size(0, 45),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    onPressed: () { Get.back(); dialogBottom(); },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : 
                          dialogBottom();
                        },
                        child: Container(
                            height: 140,
                            decoration: BoxDecoration(color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: Text("Ship", style: TextStyle(
                                    color: Colors.white),
                                )
                            )
                        )
                    ),
                  ),
                  orderDetails[0]["status"] == "Ship" ? SizedBox(width: 15) : SizedBox(width: orderDetails[0]["status"] == "Cancel" ? 0 : 15,),
                  orderDetails[0]["status"] == "Ship" || orderDetails[0]["status"] == "Deliver" ? Expanded(
                    child: InkWell(
                          onTap: () async {
                            DateTime now = DateTime.now();
                            String date = now.millisecondsSinceEpoch.toString();
                            var res = await http.post(Uri.parse(API.update_order),
                            body: {
                              'oid': widget.orderid.toString(),
                              'status' : 'Deliver',
                              'date' : date,
                            }
                            );
                            setState(() {
                              print(res.body);
                              getOrderItems();
                              getOrderDetail();
                            });
                          },
                          child: Container(
                              height: 140,
                              decoration: BoxDecoration(color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: Text("Deliver", style: TextStyle(
                                      color: Colors.white),
                                  )
                              )
                          )
                      ),
                  ) : orderDetails[0]["status"] != "Cancel" ?
                   Expanded(
                    child: InkWell(
                        onTap: () async {
                          var res = await Get.to(cancelPage(order_id: widget.orderid!,));
                          if (res == true) {
                            print(widget.orderid);
                            getOrderDetail();
                          }
                        },
                        child: Container(
                            height: 140,
                            decoration: BoxDecoration(color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: Text("Cancel", style: TextStyle(
                                    color: Colors.white),
                                )
                            )
                        )
                    ),
                  ) : Container(),
                ],
              ),
            ),
          ),
          body: _isLoading
              ? Center(child: Container(
                        height: 55,
                        width: 55,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ))
              : Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              // physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Order ID - " + widget.orderid!),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  for(int i = 0; i < orderItems!.length; i++)
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, bottom: 8, right: 16, top: 8),
                            child: Row(
                              children: [
                                Container(
                                  height: 90,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                        API.hostUrl + "/admin/" +
                                            orderItems![i]["product_image"],
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(orderItems![i]["product_name"]),
                                      SizedBox(height: 5),
                                      Text(orderItems![i]["product_category"]),
                                      SizedBox(height: 5),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text("\₹ " +
                                                  orderItems![i]["product_price"]),
                                              Text("Quantity : " +
                                                  orderItems![i]["p_quantity"]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20,bottom: 8,right: 20,top: 8),
                      child: orderDetails[0]["status"] == "Cancel" ?
                      Column(
                        children: [
                          SizedBox(height: 5,),
                          Text(
                            orderDetails[0]["cancelReason"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center, // Added textAlign to center the text
                          ),
                          Divider(),
                          int.parse(orderDetails[0]["paymentid"]) == 0 ? Container() : Row(
                            children: [
                              Icon(Icons.note_outlined, color: n10),
                              SizedBox(width: 10),
                              Text((int.parse(orderDetails[0]["paymentid"]) == 0 ? "" : "This is prepaid order."),style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: int.parse(orderDetails[0]["paymentid"]) == 0 ? 0 : 10,),
                          Row(
                            children: [
                              Icon(Icons.cancel_outlined, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Order Cancel, " + TimeConvert(orderDetails[0]["date_of_delivery"]),style: TextStyle(color: Colors.red),),
                            ],
                          ),
                        ],
                      )
                          :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.electric_scooter_rounded,),
                              SizedBox(width: 10,),
                              Text("Order Confirmed, "+TimeConvert(orderDetails[0]["o_id"])),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10 ),
                                child: Container(
                                  height: 30,
                                  width: 2.0,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 5,),
                              orderDetails[0]["status"] == "Ship" ? Container(
                                width: 30,
                                height: 2.0,
                                color: Colors.grey,
                              ): Container(),
                              orderDetails[0]["status"] == "Ship" ? Text("  Order Shipped") : Container(),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.check_circle_outline_outlined,),
                              SizedBox(width: 10,),
                              orderDetails[0]["status"] == "Deliver" ? Text("Order "+orderDetails[0]["status"]+", "+TimeConvert(orderDetails[0]["date_of_delivery"])) : Text("Expected Delivery, "+TimeConvert(orderDetails[0]["date_of_delivery"])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text("Order Summary",
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 2,),
                  Card(
                    color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Value"),
                              Text("₹" + Product_MRP(orderItems!)),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Selling Price"),
                              Text("₹" + Product_Price(orderItems!)),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Delivery Charge"),
                              Text("Free Delivery"),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Discounts"),
                              Text("₹" + orderDetails[0]["total_discounts"]),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Amount Payable",
                                style: TextStyle(fontWeight: FontWeight.bold),),
                              Text("₹" +
                                  totalPayable(orderItems!, orderDetails[0]),
                                style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Text("Payment Status: ",),
                              Text((int.parse(orderDetails[0]["paymentid"]) == 0
                                  ? "COD"
                                  : "Prepaid"), style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color.fromARGB(255, 221, 238, 200),),
                              height: 40,
                              child: Center(child: Text("You saved ₹" +
                                  totalSave(orderDetails[0], orderItems!) +
                                  " on this order",style: TextStyle(color: Colors.black,),))
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("Delivery address",
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 2,),
                  Card(
                    color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person_outlined, size: 16,),
                                  SizedBox(width: 5,),
                                  Text(orderDetails[0]["name"]),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.place_outlined, size: 16,),
                                  SizedBox(width: 5,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(orderDetails[0]["street"] + ","),
                                      Text(orderDetails[0]["landmark"] + ", " +
                                          orderDetails[0]["city"]),
                                      Text(orderDetails[0]["state"] + " - " +
                                          orderDetails[0]["pincode"]),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Icon(Icons.call_outlined, size: 16,),
                                  SizedBox(width: 5,),
                                  InkWell(onTap: () async {
                                    String phoneNumber = orderDetails[0]["mono"];
                                    if (await canLaunch("tel:$phoneNumber")) {
                                      await launch("tel:$phoneNumber");
                                    } else {
                                      print("Could not launch phone dialer");
                                    }
                                  }, child: Text(orderDetails[0]["mono"])),
                                ],
                              ),
                            ],
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
      );
    }catch(e){
      setState(() {
        _isLoading = true;
      });
      print("error $e");
      return Scaffold(
        body: Center(child: _isLoading ? Container(
                        height: 55,
                        width: 55,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ) : null,),
      );
    }
  }
}

class cancelPage extends StatefulWidget {
  String? order_id;
  cancelPage({this.order_id,super.key});

  @override
  State<cancelPage> createState() => _cancelPageState();
}

class _cancelPageState extends State<cancelPage> {

  int? _selectedValue = 1;
  List<String> cancelReasons = [
    "Shipping delay",
    "Incorrect address/contact details",
    "Incorrect size ordered",
    "Out of stock",
    "Payment Issues",
    "Technical Issues",
    "Other reasons",
  ];
  void _handleRadioValueChange(int? value) {
    // Handle radio button selection here
    print('Selected value: $value');
    setState(() {
      _selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("E-lite",style: TextStyle(color: n10,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
          ),
          child: InkWell(
            onTap: () async{
              try {
                DateTime date = DateTime.now();
                String d_date = date.millisecondsSinceEpoch.toString();
                var res = await http.post(
                  Uri.parse(API.place_order),
                  body: {
                    "o_id": (widget.order_id).toString(),
                    "date": (d_date).toString(),
                    "cancelReason": "Admin cancel the order because "+(cancelReasons[_selectedValue!-1]).toString(),
                  },
                );
                var response = jsonDecode(res.body);
                if(res.statusCode == 200) {
                  print("Update Successfully..!");
                  if(response['success'] == true) {
                    print("successfully");
                    Get.back(result: true);
                  } else {
                    print("Not Successfully..!");
                  }
                } else {
                  print("Not Updated..!");
                }
              } catch(e) {
                print(e.toString());
              }
            },
            child: Center(
              child: Text("Cancel",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,),),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 14,right: 14,top: 0,bottom: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Order No: "+widget.order_id!,style: TextStyle(fontSize: 14),),
                      SizedBox(height: 10,),
                      Text("Ordered On: "+_OrderDetailPageState().TimeConvert(widget.order_id!),style: TextStyle(fontSize: 14),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select a reason for cancellation",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          cancelReasons.length,
                              (index) => Container(
                            height: 38,
                            child: RadioListTile<int>(
                              activeColor: Colors.indigoAccent,
                              title: Text(cancelReasons[index],style: TextStyle(fontSize: 14),),
                              value: index + 1,
                              groupValue: _selectedValue,
                              onChanged: (int? value) {
                                // Handle radio button selection
                                _handleRadioValueChange(value);
                              },
                            ),
                          ),
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
    );
  }
}
