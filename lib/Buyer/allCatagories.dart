import 'package:flutter/material.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/utils/fonts.dart';
import 'package:transact/utils/utils.dart';

class AllCategories extends StatefulWidget {
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: HexColor("#F5F7FA"),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: CustomeAppBar(
                title: "Categories",
                homepage: false,
              ),
            ),
            body: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight),
                        child: Column(
                          children: <Widget>[_allCategories()],
                        )));
              },
            )));
  }

  Widget _allCategories() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          alignment: Alignment.centerLeft,
          child: Text(
            "All Categories",
            style: blackbold.copyWith(fontSize: 24),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _category("images/apparel.png", "Apparel"),
                  _category("images/beauty.png", "Beauty"),
                  _category("images/shoes.png", "Shoes"),
                  _category("images/electronics.png", "Electronics"),
                  _category("images/furniture.png", "Furniture"),
                  _category("images/stationary.png", "Stationary"),
                  _category("images/apparel.png", "Food"),
                  _category("images/beauty.png", "Massage"),
                  _category("images/shoes.png", "Technician"),
                  _category("images/electronics.png", "Cleaning"),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                 margin: EdgeInsets.only(right: 20),
                child: Column(
                  children: <Widget>[
                    _title("MEN'S APPAREL"),
                    _menApparel(),
                    _divider(),
                    _title("WOMEN APPAREL"),
                    _womenApparel(),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
  Widget _divider(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 0.5,
      color: HexColor("#727C8E")
    );
  }

  Widget _menApparel() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          _tile("T-Shirts"),
          _tile("Shirt"),
          _tile("Pants & Jeans"),
          _tile("Socks & Ties"),
          _tile("UnderWear"),
          _tile("Jackets"),
          _tile("Coats"),
          _tile("Sweaters")
        ],
      ),
    );
  }
   Widget _womenApparel() {
    return Container(
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          _tile("Office Wear"),
          _tile("Blouse & T-Shirt"),
          _tile("Pants & Jeans"),
          _tile("Dresses"),
          _tile("Lingerie"),
          _tile("Jackets"),
          _tile("Coats"),
          _tile("Sweaters")
        ],
      ),
    );
  }

  Widget _title(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 10),
      child:
          Text("$text", style: blackbold.copyWith(color: HexColor("#515C6F"))),
    );
  }

  Widget _tile(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        onTap: (){print("$text");},
        dense: true,
        title: Text(
          "$text",
          style: blackbold.copyWith(fontWeight: FontWeight.normal),
        ),
        trailing: Image(
          height: 30,
          width: 25,
          image: AssetImage("images/forward_icon.png"),
        ),
      ),
    );
  }

  Widget _category(String image, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 5,top: 5),
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: 70,
            width:70,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Image(
              image: AssetImage("$image"),
            ),
          ),
          Text(
            "$text",
            style: catagoryFont.copyWith(height: 0.0, fontSize: 13),
          )
        ],
      ),
    );
  }
}
