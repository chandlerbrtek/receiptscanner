import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';


import 'package:receipt/data/db.dart';
import 'package:receipt/data/models.dart';

// Budget Overview Page

/// Page for displaying all budgets within the system. All budgets are
/// queried from the database and displayed to the screen in tiles.
class Budgets extends StatefulWidget { 

  /// The route for the budget listing page within the application.
  static const String ROUTE = '/budgets';
  
  /// The method for navigating to the budget listing page.
  static view(BuildContext context) {
    Navigator.popAndPushNamed(context, ROUTE);
  }

  createState() => _BudgetListState();
}

class _BudgetListState extends State<Budgets> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budgets"),
      ),
      body: _budgetList(),
    );
  }

  /// Retrieves all budgets from the database.
  Future<List<Budget>> _fetch() {
    return databaseAPI.getAllBudgets();
  }

  /// Lists all budgets on the screen.
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
              
              return _budgetTile(context, item);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  /// Creates a budget tile for a given budget.
  Widget _budgetTile(BuildContext context, Budget budget) {
    final formatCurrency = new NumberFormat.simpleCurrency();

    return RaisedButton(
      onPressed: () => Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) =>
          new EditBudget(budget: budget), 
        )
      ),
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  budget.name,
                  textScaleFactor: 1.36,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  formatCurrency.format(budget.amount / 100),
                  textScaleFactor: 1.36,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  )
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
              ),
              child: LinearPercentIndicator(
                percent: budget.progress / budget.amount,
                isRTL: false,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                lineHeight: 24,
                center: Text(
                  formatCurrency.format(budget.progress / 100),
                  textScaleFactor: 1.36,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                progressColor: Theme.of(context).accentColor,
                animation: true,
                animationDuration: 1000,
              )
            ),
          ],
        ),
      ),
    );
  }
}

// Individual Budget Interaction Pages

/// Page for adding a new budget to the system.
class AddBudget extends StatefulWidget {

  Budget budget;

  @override
  createState() => _AddBudgetState();

}

/// Page for editing an existing budget within the system.
class EditBudget extends StatefulWidget {

  Budget budget;  

  EditBudget({Key key, @required this.budget}) : super(key: key);

  @override
  createState() => _EditBudgetState();

}

/// State for adding a new budget to the system.
class _AddBudgetState extends State<AddBudget> {

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    
  }
  
}

/// State for editing an existing budget within the system.
class _EditBudgetState extends State<EditBudget> {

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold( 
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              initialValue: widget.budget.name,
              decoration: InputDecoration(labelText: 'Budget Name'),
              onSaved: (input) => setState(() => widget.budget.name = input),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: _update,
                    child: Text('Update Budget'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
    
  }

  void _update() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      databaseAPI.updateBudget(widget.budget);

      Navigator.pop(context);
    } else {
      print('Not updated...');
    }
  }

}








// class BudgetForm extends StatefulWidget {

//   @override
//   _BudgetFormState createState() => _BudgetFormState();

// }

// class _BudgetFormState extends State<BudgetForm> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           TextFormField(
//           ),
//           TextField(
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: RaisedButton(
//                   onPressed: _submit,
//                   child: Text('Submit Budget'),
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   void _submit() {
//     if (_formKey.currentState.validate()) {
//       _formKey.currentState.save();
//       Budget budget = Budget();
//       print('Budget generated:');
//       print(budget.toMap());
//       databaseAPI.addBudget(budget);

//       Navigator.pop(context);
//     } else {
//       print('Invalid Form State');
//     }
//   }
// }





// class EditBudget extends StatelessWidget {
  
//   final Budget budget;

//   EditBudget({Key key, @required this.budget}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Budget"),
//       ),
//       body: Card(
//         child: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: BudgetForm(
            
//           )
//         )
//       )
//     );
//   }
// }