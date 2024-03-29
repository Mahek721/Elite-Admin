import 'dart:convert';
import 'package:elite_admin_panel/Screen/update_product.dart';
import 'package:elite_admin_panel/Theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:elite_admin_panel/API/api.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class AdminProductDescriptions extends StatefulWidget{

  String pid;
  String pname;
  String ptitle;
  String pdesc;
  String pcat;
  String pbrand;
  String pprice;
  String pimage;
  String mprice;
  String stock;
  final String photo;
  AdminProductDescriptions({
    super.key,
    required this.pid,
    required this.pname,
    required this.ptitle,
    required this.pdesc,
    required this.pcat,
    required this.pbrand,
    required this.pprice,
    required this.mprice,
    required this.stock,
    required this.pimage,
    required this.photo,
  });


  @override
  State<AdminProductDescriptions> createState() => AdminProductDescriptions_state();  
}

class AdminProductDescriptions_state extends State<AdminProductDescriptions>{

  deleteProduct() async {
    try {
      var res = await http.post(
        Uri.parse(API.deleteProduct),
        body: {
          'product_id': widget.pid,
        },
      );
      if(res.statusCode == 200) {
        var resBodyOfSignup = jsonDecode(res.body);

        if(resBodyOfSignup['success'] == true) {
          // Fluttertoast.showToast(msg: "Delete Successfully..!");
          Get.offAll(Home_page_admin());
        } else {
          // Fluttertoast.showToast(msg: "Error occured try again..!");
        }
      }
    } catch(e) {
      print(e.toString());
      // Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20,),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                deleteProduct();
              },
              child: Container(
                height: 48,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: themeChange.darkTheme ? Colors.grey[800] : Colors.grey.shade300,
                ),
                child: Icon(CupertinoIcons.delete_simple),
              ),
            ),
            const SizedBox(width: 20,),
            InkWell(
              onTap: () {
                Get.to(UpdateProduct(
                  pid: widget.pid,
                  pname: widget.pname,
                  ptitle: widget.ptitle,
                  pdesc: widget.pdesc,
                  pcat: widget.pcat,
                  pbrand: widget.pbrand,
                  pprice: widget.pprice,
                  pimage: widget.pimage,
                  mprice: widget.mprice,
                  stock: widget.stock,
                ));
              },
              child: Container(
                height: 50,
                width: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: themeChange.darkTheme ? Colors.grey[800] : Colors.black,
                ),
                child: Center(child: Text("Update Product",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),)),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Container(
                  width: 280,
                  child: Hero(
                    tag: widget.photo,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15),topRight: Radius.circular(15),topLeft: Radius.circular(15),),
                      child: Image.network(widget.pimage,fit: BoxFit.fitWidth,height: 400,width: 380,),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20,),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Text(widget.pname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                        SizedBox(width: 5,),
                        Text("${widget.pcat}",style: TextStyle(color: Colors.grey,fontSize: 14),)
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(children: [
                      Text("\₹"+widget.pprice,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      SizedBox(width: 10,),
                      Text(widget.mprice,style: TextStyle(fontSize: 12,decoration: TextDecoration.lineThrough),),
                      SizedBox(width: 10,),
                      Text('${((1 - (double.parse(widget.pprice) / double.parse(widget.mprice))) * 100).toStringAsFixed(2)}% off',style: TextStyle(color: Colors.green,fontSize: 12),),
                    ],),
                    SizedBox(height: 15,),
                    Text(widget.ptitle,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    SizedBox(height: 15,),
                    Text("Description",style: TextStyle(color: Colors.grey,fontSize: 14),),
                    SizedBox(height: 08,),
                    Text(widget.pdesc,style: TextStyle(fontSize: 15),),
                    SizedBox(height: 15,),
                    Text("Brand",style: TextStyle(color: Colors.grey,fontSize: 14),),
                    Text(widget.pbrand,style: TextStyle(fontSize: 15),),
                    SizedBox(height: 15,),
                    Text("Product Stock Availability : ",style: TextStyle(color: Colors.grey,fontSize: 14),),
                    Text(widget.stock,style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}