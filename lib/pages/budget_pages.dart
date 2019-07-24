import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


import 'package:receipt/data/db.dart';
import 'package:receipt/data/models.dart';

// class BudgetViewer extends StatelessWidget {

//   Budget budget;

//   BudgetViewer({Budget budget});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Monthly Budget"),
//       ),
//       body: Material(
//         type: MaterialType.transparency,
//         child: new Container(
//           decoration: new BoxDecoration(color: Colors.white),
//           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
//           alignment: Alignment.topCenter,
//         )
//       ),
//     );
//   }

// }

class Budgets extends StatelessWidget { 

  static const String ROUTE = '/budgets';
  
  static view(BuildContext context) {
    Navigator.popAndPushNamed(context, ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budgets"),
      ),
      body: _budgetList(),
    );
  }

  Future<List<Budget>> _fetch() {
    return databaseAPI.getAllBudgets();
  }

  FutureBuilder<List<Budget>> _budgetList() {
    return FutureBuilder<List<Budget>>(
      future: _fetch(),
      builder: (BuildContext context, AsyncSnapshot<List<Budget>> snapshot) {
        if (snapshot.hasData) {
          final length = snapshot.data.length;
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: length,
            itemBuilder: (BuildContext context, int index) {
              final Budget item = snapshot.data[index];
              final formatCurrency = new NumberFormat.simpleCurrency();
              return Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          item.name,
                          textScaleFactor: 1.36,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          formatCurrency.format(item.amount / 100),
                          textScaleFactor: 1.36,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          )
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: item.progress / item.amount,
                            child: Text(''),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              border: Border(
                                right: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                            ),
                          ),
                          Text(formatCurrency.format(item.progress / 100)),
                        ]
                      )
                    )
                  ],
                )
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}