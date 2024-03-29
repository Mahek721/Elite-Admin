import 'package:elite_admin_panel/Theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PtrofileScreen extends StatefulWidget {
  const PtrofileScreen({super.key});

  @override
  State<PtrofileScreen> createState() => _PtrofileScreenState();
}

class _PtrofileScreenState extends State<PtrofileScreen> {
  
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    void toggleSwitch(bool value) {
      if (themeChange.darkTheme == false) {
        setState(() {
          themeChange.darkTheme = true;
        });
      } else {
        setState(() {
          themeChange.darkTheme = false;
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",style: TextStyle(fontWeight: FontWeight.w900),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10,),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Icon(CupertinoIcons.person,color: Colors.black,),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Admin",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),),
                              SizedBox(height: 5,),
                              Text("admin@gmail.com",style: TextStyle(fontWeight: FontWeight.normal),),
                            ],
                          ),
                        ],
                      ),
                      Icon(CupertinoIcons.chevron_forward,size: 18,),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,),
                  child: Divider(color: Colors.grey,),
                ),
                SizedBox(height: 20,),
                ListTile(
                  onTap: () {
                    // Get.to(UploadProduct());
                  },
                  leading: Text("Add Product"),
                  trailing: Icon(Icons.dashboard_outlined,size: 18,),
                ),
                ListTile(
                  onTap: () {
                    // Get.to(allUser());
                  },
                  leading: Text("All Users"),
                  trailing: Icon(CupertinoIcons.person_2,size: 18,),
                ),
                ListTile(
                  onTap: () {
                    // Get.to(OrderPage());
                  },
                  leading: Text("All Orders"),
                  trailing: Icon(CupertinoIcons.bag,size: 18,),
                ),
                ListTile(
                  leading: Text("Theme"),
                  trailing: Switch(
                    onChanged: toggleSwitch,
                    value: themeChange.darkTheme,
                    activeColor: Colors.indigo.shade200,
                  ),
                ),
                ListTile(
                  leading: Text("Logout"),
                  trailing: Icon(Icons.power_settings_new_outlined,size: 18,),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 20,
        child: Center(child: Text("Version : 1.0.1"))),
    );
  }
}
