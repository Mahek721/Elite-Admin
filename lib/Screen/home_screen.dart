import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elite_admin_panel/Screen/product_detail.dart';
import 'package:elite_admin_panel/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../API/api.dart';

class Home_page_admin extends StatefulWidget {
  const Home_page_admin({super.key});

  @override
  State<Home_page_admin> createState() => Home_page_admin_state();
}

class Home_page_admin_state extends State<Home_page_admin>{

  var bannerImageUrl = [
    "assets/banner/buds.jpg",
    "assets/banner/headphone.jpg",
    "assets/banner/mobile.jpg",
    "assets/banner/watch.jpg",
  ];

  List<dynamic> list = [];

  Future<void> getData() async {
    var res = await http.get(
      Uri.parse(API.viewProduct),
    );
    var response = jsonDecode(res.body);
    setState(() {
      list = response;
      print(response);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  int calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth ~/ 170;
    return crossAxisCount;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("E-Lite",style: TextStyle(fontWeight: FontWeight.w900,)),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context, 
                  delegate: DataSearch(list));
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => getData(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: bannerImageUrl.length, 
                  itemBuilder: (context, index, realIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5,),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.grey[300]!,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(bannerImageUrl[index],fit: BoxFit.cover,)),
                      ),
                    );
                  }, 
                  options: CarouselOptions(
                    aspectRatio: 16/8,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3,),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                ),                
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Popular Products",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  // height: 350,
                  child: list.length != 0 ?
                        GridView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        itemCount: list.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: calculateCrossAxisCount(context),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(
                            onTap: () {
                              Get.to(AdminProductDescriptions(
                                photo: "${API.hostUrl}/admin/"+list[index]['product_image'],
                                pid: list[index]['product_id'],
                                pname: list[index]['product_name'],
                                ptitle: list[index]['product_title'],
                                pdesc: list[index]['product_desc'],
                                pbrand: list[index]['product_brand'],
                                pcat: list[index]['product_category'],
                                pprice: list[index]['product_price'],
                                stock: list[index]['product_stock'],
                                mprice: list[index]['product_mrp'],
                                pimage: "${API.hostUrl}/admin/"+list[index]['product_image'],
                              ));
                            },
                            image: API.hostUrl +
                                "/admin/" +
                                list[index]["product_image"],
                            name: list[index]["product_title"],
                            category: list[index]["product_category"],
                            price: double.parse(list[index]["product_price"]),
                            product_stock: list[index]['product_stock'],
                          );
                        },
                      )
                      :
                      Center(child: Container(
                        height: 55,
                        width: 55,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ),)
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  String? image;
  String? name;
  String? product_stock;
  String? category;
  double? price;

  void Function()? onTap;

  ProductCard({
    Key? key,
    this.image,
    this.name,
    this.category,
    this.price,
    this.product_stock,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: themeChange.darkTheme ? Colors.grey[900] : Colors.grey[200],
                  // border: Border.all(
                  //   style: BorderStyle.solid,
                  //   color: Colors.grey,
                  // ),
                  borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 90,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(image!, fit: BoxFit.fitHeight),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name!,
                                  style: TextStyle(
                                    // color: n10,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Container(
                                  child: price == null
                                      ? Container()
                                      : Text(
                                          "\₹ ${price}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          int.parse(product_stock!) == 0
          ? Positioned(
              top: 0,
              left: 0,
              child: Banner(
                message: "Out of stock",
                location: BannerLocation.topStart,
                color: Colors.red,
              ),
            )
          : SizedBox(),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<dynamic> list;

  DataSearch(this.list);

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
    final filteredData = list
        .where((item) => item['product_name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredData[index]['product_name']),
          onTap: () {
            close(context, filteredData[index]['product_name']);
            // Get.to(searchResult(search: query,));
          },
        );
      },
    );
  }

  @override
  TextInputAction get textInputAction => TextInputAction.search;

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    // Get.to(searchResult(search: query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestedData = list
        .where((item) => (item['product_name'].toLowerCase()).contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestedData.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestedData[index]['product_name']),
          onTap: () {
            query == null || query == "" ? query = suggestedData[index]['product_name'] : 
            showResults(context);
            // Get.to(searchResult(search: query,));
          },
        );
      },
    );
  }
}
