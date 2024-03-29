import 'dart:convert';
import 'package:elite_admin_panel/API/api.dart';
import 'package:elite_admin_panel/Screen/home_screen.dart';
import 'package:elite_admin_panel/Screen/product_detail.dart';
import 'package:elite_admin_panel/Theme/theme_provider.dart';
import 'package:elite_admin_panel/constantns/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart' as s;
import 'package:http/http.dart' as http;

class searchResult extends StatefulWidget {
  final String? search;
  searchResult({this.search,super.key});

  @override
  State<searchResult> createState() => _searchResultState();
}

class _searchResultState extends State<searchResult> {

  List<dynamic> list = [];
  List<dynamic> listSearch = [];
  List<dynamic> listSearch2 = [];
  List<bool> isCheckedCategoryList = [];
  List<String> uniqueCategories = [];
  List<bool> isCheckedBrandList = [];
  List<String> uniqueBrand = [];
  List<bool> isCheckedList = [false, false, false, false, false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
    print(widget.search!);
  }

  Future<void> getList() async {
    var res = await http.get(
      Uri.parse(API.viewProduct),
    );
    var response = jsonDecode(res.body);
    setState(() {
      list = response;
      searchList();
    });
  }

  void searchList() {
    setState(() {
      listSearch = list
          .where((item) => item['product_name'].toLowerCase().contains(widget.search!.toLowerCase()))
          .toList();
      listSearch2 = listSearch;
      isCheckedCategoryList = List.generate(listSearch2.length, (index) => false);
      isCheckedBrandList = List.generate(listSearch2.length, (index) => false);
    });
  }

  int calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth ~/ 170;
    return crossAxisCount;
  }


  int? _selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Lite",style: TextStyle(fontWeight: FontWeight.w900,)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: s.DataSearch(list));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async{
                        List<dynamic> relevance = listSearch;
                        var res = await Get.bottomSheet(
                          sortDialog(value : _selectedValue)
                        );
                        if(res != null){
                          print(res);
                          setState(() {
                            _selectedValue = res;
                            if(_selectedValue == 1){
                              searchList();
                            }else if(res == 2){
                              listSearch.sort((a, b) =>
                                  double.parse(a['total_sell']).compareTo(double.parse(b['total_sell']))
                              );
                              listSearch = listSearch.reversed.toList();
                            }else if(res == 3){
                              listSearch.sort((a, b) =>
                                  double.parse(a['product_price']).compareTo(double.parse(b['product_price']))
                              );
                            }else if(res == 4){
                              listSearch.sort((a, b) =>
                                  double.parse(a['product_price']).compareTo(double.parse(b['product_price']))
                              );
                              listSearch = listSearch.reversed.toList();
                            }else if(res == 5){
                              listSearch.sort((a, b) =>
                                  double.parse(a['product_id']).compareTo(double.parse(b['product_id']))
                              );
                              listSearch = listSearch.reversed.toList();
                            }
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sort),
                          Text("Short"),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1,
                    height: 30,
                    color: const Color.fromARGB(255, 190, 186, 186),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async{
                        var res = await Get.to(filterDrawer(
                            uniqueBrand:uniqueBrand,
                            ischeckedBrandList : isCheckedBrandList,
                            listsearch : listSearch2,
                            ischeckedList : isCheckedList,
                            ischeckedCategoryList : isCheckedCategoryList,
                            search:widget.search,
                            uniqueCategories:uniqueCategories),fullscreenDialog: true,);
                        setState(() {
                          try {
                            if(res != [] || res != null){
                              listSearch = res['listsearch'];
                              if(_selectedValue == 2){
                                listSearch.sort((a, b) =>
                                    double.parse(a['total_sell']).compareTo(double.parse(b['total_sell']))
                                );
                                listSearch = listSearch.reversed.toList();
                              }else if(_selectedValue == 3){
                                listSearch.sort((a, b) =>
                                    double.parse(a['product_price']).compareTo(double.parse(b['product_price']))
                                );
                              }else if(_selectedValue == 4){
                                listSearch.sort((a, b) =>
                                    double.parse(a['product_price']).compareTo(double.parse(b['product_price']))
                                );
                                listSearch = listSearch.reversed.toList();
                              }else if(_selectedValue == 5){
                                listSearch.sort((a, b) =>
                                    double.parse(a['product_id']).compareTo(double.parse(b['product_id']))
                                );
                                listSearch = listSearch.reversed.toList();
                              }

                              isCheckedList = res['isCheckedList'];
                              isCheckedCategoryList = res['isCheckedCategoryList'];
                              isCheckedBrandList = res['ischeckedBrandList'];
                              uniqueBrand = res['uniqueBrand'];
                              uniqueCategories = res['uniqueCategories'];
                            }
                          } catch (e) {
                            print(e);
                          }

                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_list),
                          Text("Filter"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              if (listSearch.length != 0)
                GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  itemCount: listSearch.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: calculateCrossAxisCount(context),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      onTap: () {
                        Get.to(AdminProductDescriptions(
                          photo: "${API.hostUrl}/admin/"+listSearch[index]['product_image'],
                          pid: listSearch[index]['product_id'],
                          pname: listSearch[index]['product_name'],
                          ptitle: listSearch[index]['product_title'],
                          pdesc: listSearch[index]['product_desc'],
                          pbrand: listSearch[index]['product_brand'],
                          pcat: listSearch[index]['product_category'],
                          pprice: listSearch[index]['product_price'],
                          stock: listSearch[index]['product_stock'],
                          mprice: listSearch[index]['product_mrp'],
                          pimage: "${API.hostUrl}/admin/"+listSearch[index]['product_image'],
                        ));
                      },
                      image: API.hostUrl +
                          "/admin/" +
                          listSearch[index]["product_image"],
                      name: listSearch[index]["product_name"],
                      category: listSearch[index]["product_category"],
                      price: double.parse(listSearch[index]["product_price"]),
                      product_stock: listSearch[index]['product_stock'],
                    );
                  },
                )
              else
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}

class sortDialog extends StatefulWidget {
  int? value;
  sortDialog({this.value,super.key});

  @override
  State<sortDialog> createState() => _sortDialogState();
}

class _sortDialogState extends State<sortDialog> {
  int? _selectedValue;
  List<String> list = ["Relevance","Popularity","Price -- Low to High","Price -- High to Low","Newest First"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedValue = widget.value;
    });
  }
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
            color: themeChange.darkTheme ? Colors.grey[900]! : Colors.grey[300],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sort BY",style: TextStyle(fontSize: 18,color: Colors.grey,fontWeight: FontWeight.bold,),),
              SizedBox(height: 5,),
              Divider(color: Colors.grey[500],),
              for(int i=0;i<list.length;i++)
                InkWell(
                  onTap: () {
                    Get.back(result: i+1);
                  },
                  child: Container(
                    height: 35,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      trailing: Radio(
                        activeColor: Colors.indigoAccent,
                        value: i + 1,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value as int?;
                            Get.back(result: i+1);
                          });
                        },
                      ),
                      title: Text(list[i]),
                    ),
                  ),
                ),
            ],),
        ),
      ),
    );
    enableDrag: true;
  }
}

class filterDrawer extends StatefulWidget {
  List<dynamic>? listsearch;
  List<bool>? ischeckedList;
  List<bool>? ischeckedCategoryList;
  List<bool>? ischeckedBrandList;
  String? search;
  List<String>? uniqueCategories;
  List<String>? uniqueBrand;
  filterDrawer({this.listsearch,this.ischeckedList,this.ischeckedCategoryList,this.ischeckedBrandList,this.search,this.uniqueCategories,this.uniqueBrand,super.key});

  @override
  State<filterDrawer> createState() => _filterDrawerState();
}
class _filterDrawerState extends State<filterDrawer> {

  int _selectedValue = 1;
  List<dynamic> newlistsearch = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter"),
        actions: [
          TextButton(onPressed: () {
            setState(() {
              isCheckedList.fillRange(0, isCheckedList.length,false);
              isCheckedCategoryList.fillRange(0, isCheckedCategoryList.length, false);
              isCheckedBrandList.fillRange(0, isCheckedBrandList.length, false);
              newlistsearch.clear();
            });
          }, child: Text("Clear Filters",style: TextStyle(color: Colors.indigoAccent),)),
          SizedBox(width: 15,),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.listsearch!.length.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                  Text("products found",style: TextStyle(fontSize: 14,),),
                ],
              ),
              InkWell(
                onTap: () async{
                  if(!isCheckedList.contains(true) && !isCheckedCategoryList.contains(true)){
                      Get.back(result: {'uniqueBrand':uniqueBrand1, 'ischeckedBrandList' : isCheckedBrandList,'listsearch': widget.listsearch, 'isCheckedList': isCheckedList, 'isCheckedCategoryList': isCheckedCategoryList}
                      );
                  }else{
                    Map<String, dynamic> requestBody = {
                      'search': widget.search,
                    };

                    if (uniqueCategories1.isNotEmpty) {
                      requestBody['selectedCategories'] = jsonEncode(uniqueCategories1).toString();
                      print(requestBody['selectedCategories']);
                    }

                    if (uniqueBrand1.isNotEmpty) {
                      requestBody['selectedBrands'] = jsonEncode(uniqueBrand1).toString();
                      print(requestBody['selectedBrands']);
                    }

                    if (isCheckedList.isNotEmpty && isCheckedList.contains(true)){
                      requestBody['priceRange']= jsonEncode(isCheckedList);
                      print(requestBody['priceRange']);
                    }

                    var res = await http.post(
                      Uri.parse(API.get_search),
                      body: requestBody,
                    );
                    setState(() {
                      newlistsearch = jsonDecode(res.body);
                      Get.back(result: newlistsearch.isEmpty
                        ? {'uniqueBrand':uniqueBrand1, 'ischeckedBrandList' : isCheckedBrandList,'listsearch': newlistsearch, 'isCheckedList': isCheckedList, 'isCheckedCategoryList': isCheckedCategoryList,'uniqueCategories':uniqueCategories1}
                        : {'uniqueBrand':uniqueBrand1, 'ischeckedBrandList' : isCheckedBrandList,'listsearch': newlistsearch, 'isCheckedList': isCheckedList, 'isCheckedCategoryList': isCheckedCategoryList,'uniqueCategories':uniqueCategories1});
                    });
                  }
                  },
                child: Container(
                  height: 50,
                  width: 180,
                  decoration: BoxDecoration(
                    color: n10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Apply",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedValue = 1;
                        });
                      },
                      child: Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold,color: _selectedValue == 1 ? Colors.blue : Colors.grey))),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedValue = 2;
                        });
                      },
                      child: Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          child: Text("Category", style: TextStyle(fontWeight: FontWeight.bold,color: _selectedValue == 2 ? Colors.blue : Colors.grey))),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedValue = 3;
                        });
                      },
                      child: Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          child: Text("Brand", style: TextStyle(fontWeight: FontWeight.bold,color: _selectedValue == 3 ? Colors.blue : Colors.grey))),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedValue == 1)
                    Price()
                  else if (_selectedValue == 2)
                    Category()
                  else if (_selectedValue == 3)
                    Brand()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<bool> isCheckedList = [];
  List<bool> isCheckedCategoryList = [];
  List<bool> isCheckedBrandList = [];
  List<String> uniqueCategories1 = [];
  List<String> uniqueBrand1 = [];
  List<String> isCheckedTextList = ["Rs.10000 and Below", "Rs.10000 - Rs.15000", "Rs.15000 - Rs.20000", "Rs.20000 - Rs.30000", "Rs.30000 and Above"];

  Widget Price() {
    return Column(
      children: List.generate(isCheckedList.length, (index) {
        return Container(
          width: double.infinity,
          child: CheckboxListTile(
            title: Text(
              '${isCheckedTextList[index]}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            activeColor: Colors.indigoAccent,
            value: isCheckedList[index],
            onChanged: (value) {
              setState(() {
                isCheckedList[index] = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
          ),
        );
      }),
    );
  }

  @override
  void initState(){
    super.initState();

    setState(() {
      isCheckedList = widget.ischeckedList!;
      isCheckedCategoryList = widget.ischeckedCategoryList!;
      uniqueCategories1 = widget.uniqueCategories!;
      isCheckedBrandList = widget.ischeckedBrandList!;
      uniqueBrand1 = widget.uniqueBrand!;
    });
  }

  Widget Category() {
    List<String> uniqueCategories = widget.listsearch!
        .map((item) => item["product_category"].toString())
        .toSet()
        .toList();

    return Column(
      children: List.generate(uniqueCategories.length, (index) {
        return Container(
          width: double.infinity,
          child: CheckboxListTile(
            activeColor: Colors.indigoAccent,
            title:TextFun(uniqueCategories[index]),
            value: isCheckedCategoryList[index],
            onChanged: (value) {
              print(value);
              setState(() {
                isCheckedCategoryList[index] = value ?? false;
                if (!isCheckedCategoryList[index]) {
                  uniqueCategories1.remove(uniqueCategories[index]);
                } else {
                  uniqueCategories1.add(uniqueCategories[index]);
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
          ),
        );
      }),
    );
  }

  TextFun(String text){
    String formattedText =
        text.substring(0, 1).toUpperCase() + text.substring(1).toLowerCase();

    return Text(
      formattedText,
      style: TextStyle(
        fontSize: 14,
      ),
    );
  }

  Widget Brand() {
    List<String> uniqueBrand = widget.listsearch!
        .map((item) => item["product_brand"].toString().toLowerCase())
        .toSet()
        .toList();

    return Column(
      children: List.generate(uniqueBrand.length, (index) {
        return Container(
          width: double.infinity,
          child: CheckboxListTile(
            activeColor: Colors.indigoAccent,
            title:TextFun(uniqueBrand[index]),
            value: isCheckedBrandList[index],
            onChanged: (value) {
              print(value);
              setState(() {
                isCheckedBrandList[index] = value ?? false;
                if (!isCheckedBrandList[index]) {
                  uniqueBrand1.remove(uniqueBrand[index]);
                } else {
                  uniqueBrand1.add(uniqueBrand[index]);
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
          ),
        );
      }),
    );
  }
}