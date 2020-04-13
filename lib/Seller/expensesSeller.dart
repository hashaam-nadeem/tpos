import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Seller/addExpense.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/datetimepicker.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';

class ExpensesSeller extends StatefulWidget {
  @override
  _ExpensesSellerState createState() => _ExpensesSellerState();
}

class _ExpensesSellerState extends State<ExpensesSeller> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  var style = TextStyle(
      fontFamily: "CaviarDreams", fontSize: 16, fontWeight: FontWeight.bold);
  var formattedDateTime =
      DateFormat("dd-MM-yyyy  hh:mm a").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor("#F5F7FA"),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomeAppBar(
              homepage: false,
              title: "Expenses",
            ),
          ),
          bottomNavigationBar: BottomButton(
            name: "+ ADD NEW EXPENSE",
            ontap: () {
              AppRoutes.push(context, AddExpenseSeller());
            },
          ),
          body: Container(
              child: Container(
            child: Column(
              children: <Widget>[
                _datePicker(),
                Container(
                    height: MediaQuery.of(context).size.height * .709,
                    child: _expenseCardList()),
              ],
            ),
          ))),
    );
  }

  Widget _expenseCardList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return _expensCard();
      },
    );
  }

  Widget _expensCard() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey[200],
          blurRadius: 5,
        )
      ]),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 5, bottom: 8, top: 2),
            child: Text(
              "Expense Name",
              style: style,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, bottom: 5, top: 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: AssetImage("images/blankImage1.png"),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.only(left: 6),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing"
                      "sed do eiusmod tempor incididunt"
                      "labore et dolore magna aliqua.",
                      style: style.copyWith(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "\$25",
              style: style,
            ),
          )
        ],
      ),
    );
  }

  Widget _datePicker() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 0.0, left: 10, right: 10),
      child: DateTimeField(
        decoration: InputDecoration(
            hintText: "Select Date and Time",
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    );
  }
}
