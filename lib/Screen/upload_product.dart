import 'dart:convert';
import 'dart:io';
import 'package:elite_admin_panel/Screen/home_screen.dart';
import 'package:elite_admin_panel/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../API/api.dart';

class UploadProduct extends StatefulWidget{
  const UploadProduct({super.key});

  @override
  State<UploadProduct> createState() => UploadProduct_state();

}

class UploadProduct_state extends State<UploadProduct>{


  TextEditingController _productnameController = TextEditingController();
  TextEditingController _producttitleController = TextEditingController();
  TextEditingController _productdescController = TextEditingController();
  TextEditingController _productcategoryController = TextEditingController();
  TextEditingController _productpriceController = TextEditingController();
  TextEditingController _productMRPriceController = TextEditingController();
  TextEditingController _productstockController = TextEditingController();
  TextEditingController _productbrandController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLocalImage = false;
  String? imageName;
  String? imageData;
  XFile? getImage2;
  ImagePicker imagePicker = new ImagePicker();
  Future<void> getImage() async {
    var getImage = await imagePicker.pickImage(source: ImageSource.gallery);
    print(getImage!.path);
    List<int> imageBytes = await getImage.readAsBytes();
    imageData = base64Encode(imageBytes);

    setState(() {
      imageName = getImage.name;
      getImage2 = getImage;
      print("path : "+getImage2!.path);
      isLocalImage = !getImage2!.path.startsWith('blob') && !getImage2!.path.startsWith('https') && !getImage2!.path.startsWith('http');
    });
  }

  
  Future<void> uploadProduct() async {
    try {
      var res = await http.post(
        Uri.parse(API.insertProduct),
        body: {
          "product_name": _productnameController.text.trim(),
          "product_title": _producttitleController.text.trim(),
          "product_desc": _productdescController.text.trim(),
          "product_category": _productcategoryController.text.trim(),
          "product_brand": _productbrandController.text.trim(),
          "product_price": _productpriceController.text.trim(),
          "product_mrp" : _productMRPriceController.text.trim(),
          "product_stock" : _productstockController.text.trim(),
          "image_name": imageName,
          "image_data": imageData,
        },
      );
      var response = jsonDecode(res.body);
      if(res.statusCode == 200) {
        print("Upload Successfully..!");
        if(response['success'] == true) {
          print("successfully");
        } else {
          print("Not Successfully..!");
        }
      } else {
        print("Not Upload..!");
      }
    } catch(e) {
      print(e.toString());
      // Fluttertoast.showToast(msg: e.toString());
    }
    setState(() {
      Get.offAll(Home_page_admin());
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Lite",style: TextStyle(fontWeight: FontWeight.bold,)),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  getImage2 != null ?
                  Container(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: isLocalImage
                      ? Image.file(File(getImage2!.path), fit: BoxFit.cover)
                      : Image.network(getImage2!.path, fit: BoxFit.cover),
                    ),
                  ) : Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: themeChange.darkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Icon(Icons.image),
                    ),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: () {
                    getImage();
                  }, child: Text("Choose Image")),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _productnameController,
                    validator: (val) => val == "" ? "Please write product name" : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[300],
                      hintText: "Product Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _producttitleController,
                    validator: (val) => val == "" ? "Please write product title" : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[300],
                      hintText: "Product Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    maxLines: null,
                    minLines: 4,
                    controller: _productdescController,
                    validator: (val) => val == "" ? "Please write product desc" : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[300],
                      hintText: "Product Descriptions",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _productcategoryController,
                    validator: (val) => val == "" ? "Please write product category" : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[300],
                      hintText: "Product Category",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _productbrandController,
                    validator: (val) => val == "" ? "Please write product brand" : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[300],
                      hintText: "Product Brand",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _productMRPriceController,
                    validator: (val) => val == "" ? "Please write product MRP" : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[300],
                      hintText: "Product MRP",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _productpriceController,
                    validator: (val) {
                      if (val == "") {
                        return "Please write product price";
                      }

                      double mrp = double.tryParse(_productMRPriceController.text) ?? 0.0;

                      double price = double.tryParse(val!) ?? 0.0;

                      if (price >= mrp) {
                        return "Product price should be lower than MRP";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[300],
                      hintText: "Product Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _productstockController,
                    validator: (val) => val == "" ? "Please write product quantity" : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: themeChange.darkTheme ? Colors.grey[800] : Colors.grey[300],
                      hintText: "Product Stock",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide(
                      //     color: themeChange.darkTheme ? Colors.grey[800]! : Colors.grey[300]!,
                      //   ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14,vertical: 6,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10,),
        child: InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              if(getImage2 != null) {
                uploadProduct();
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please Image Select'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text("Add Product",style: TextStyle(fontWeight: FontWeight.bold,),),),
          ),
        ),
      ),
    );
  }
}