import 'dart:convert';
import 'dart:io';
import 'package:elite_admin_panel/Screen/home_screen.dart';
import 'package:elite_admin_panel/Theme/theme_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../API/api.dart';

class UpdateProduct extends StatefulWidget {

  String pid;
  String pname;
  String ptitle;
  String pdesc;
  String pcat;
  String pbrand;
  String pprice;
  String mprice;
  String stock;
  String pimage;
  UpdateProduct({
    super.key,
    required this.pid,
    required this.pname,
    required this.ptitle,
    required this.pdesc,
    required this.pcat,
    required this.pbrand,
    required this.pprice,
    required this.pimage,
    required this.mprice,
    required this.stock,
  });

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {

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
  XFile? getImage2;
  String? imageName;
  String? imageData; 
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
  Future<void> updateProduct() async {
    print(widget.pid);
    print(_productnameController.text.trim());
    print(_producttitleController.text.trim());
    print(_productcategoryController.text.trim());
    print(_productpriceController.text.trim());
    print(imageName);
    print(imageData);

    try {
      var res = await http.post(
        Uri.parse(API.updateProduct),
        body: {
          "product_id": widget.pid,
          "product_name": _productnameController.text.trim(),
          "product_title": _producttitleController.text.trim(),
          "product_desc": _productdescController.text.trim(),
          "product_category": _productcategoryController.text.trim(),
          "product_brand": _productbrandController.text.trim(),
          "product_price": _productpriceController.text.trim(),
          "product_mrp" : _productMRPriceController.text.trim(),
          "product_stock" : _productstockController.text.trim(),
          "image_name": imageName ?? "",
          "image_data": imageData ?? "",
        },
      );
      var response = jsonDecode(res.body);
      if(res.statusCode == 200) {
        // Fluttertoast.showToast(msg: "Update Successfully..!");
        if(response['success'] == true) {
          // Fluttertoast.showToast(msg: "successfully");
          Get.offAll(Home_page_admin());
        } else {
          // Fluttertoast.showToast(msg: "Not Successfully..!");
        }
      } else {
        // Fluttertoast.showToast(msg: "Not Updated..!");
      }
    } catch(e) {
      print(e.toString());
      // Fluttertoast.showToast(msg: e.toString());
    }
    setState(() {
      Get.off(Home_page_admin());
    });
  }

  @override
  void initState() {
    super.initState();
    // Fluttertoast.showToast(msg: "Pid : ${widget.pid}");
    setState(() {
      _productnameController.text = widget.pname;
      _producttitleController.text = widget.ptitle;
      _productdescController..text = widget.pdesc;
      _productcategoryController.text = widget.pcat;
      _productbrandController.text = widget.pbrand;
      _productpriceController.text = widget.pprice;
      _productstockController.text = widget.stock;
      _productMRPriceController.text = widget.mprice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20,),
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
                    ),
                    child: Image.network(widget.pimage,fit: BoxFit.cover,),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: () {
                    getImage();
                  }, child: Text("Choose Image")),
                  SizedBox(height: 10,),
                  TextFormField(
                    // initialValue: widget.pname,
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
                    // initialValue: widget.ptitle,
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
                    // initialValue: widget.pdesc,
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
                    // initialValue: widget.pcat,
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
                    // initialValue: widget.pprice,
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
                  SizedBox(height: 20,),
                  // ElevatedButton(onPressed: () {
                  //   if (_formKey.currentState!.validate()) {
                  //     updateProduct();
                  //   }
                  // }, child: Text("Update Product")),
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
              updateProduct();
            }
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text("Update Product",style: TextStyle(fontWeight: FontWeight.bold,),),),
          ),
        ),
      ),
    );
  }
}