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
      floatingActionButton: _addButton(),
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

  FloatingActionButton _addButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) =>
          new AddBudget(), 
        )
      ),
      child: Icon(Icons.add),
    );
  }

}

// Individual Budget Interaction Pages

/// Page for adding a new budget to the system.
class AddBudget extends StatefulWidget {

  AddBudget({Key key}) : super(key: key);

  final Budget budget = new Budget();

  @override
  createState() => _AddBudgetState();

}

/// Page for editing an existing budget within the system.
class EditBudget extends StatefulWidget {

  final Budget budget;  

  EditBudget({Key key, @required this.budget}) : super(key: key);

  @override
  createState() => _EditBudgetState();

}

/// State for adding a new budget to the system.
class _AddBudgetState extends State<AddBudget> {

  final _formKey = GlobalKey<FormState>();

  static final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  DateTime _startDate;
  DateTime _endDate;

  @override
  void initState() {
    super.initState();

    _startDate = DateTime.now();
    _endDate = _startDate.add(Duration(days: 30));

    _startController.text = dateFormat.format(_startDate);
    _endController.text = dateFormat.format(_endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Budget'),        
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: "",
                  decoration: InputDecoration(labelText: 'Budget Name'),
                  enabled: true,
                  onSaved: (input) => setState(() => widget.budget.name = input),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Start Date:'),
                  enabled: true,
                  cursorWidth: 0,
                  controller: _startController,
                  onTap: () => _selectStartDate(context),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'End Date:'),
                  enabled: true,
                  cursorWidth: 0,
                  controller: _endController,
                  onTap: () => _selectEndDate(context),
                ),
                TextFormField(
                  initialValue: "",
                  decoration: InputDecoration(labelText: 'Budget Amount'),
                  enabled: true,
                  onSaved: (input) => setState(() => widget.budget.amount = (double.parse(input) * 100).toInt()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: _submit,
                        child: Text('Submit Budget'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    //https://github.com/flutter/flutter/issues/7247#issuecomment-348269522
    //https://stackoverflow.com/a/44991969
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2020));

    if (picked != null) {
      print('date selected: $picked');

      setState(() => _startDate = picked);
      _startController.text = dateFormat.format(picked);
    }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    //https://github.com/flutter/flutter/issues/7247#issuecomment-348269522
    //https://stackoverflow.com/a/44991969
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2020));

    if (picked != null) {
      print('date selected: $picked');

      setState(() => _endDate = picked);
      _endController.text = dateFormat.format(picked);
    }
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.budget.progress = 0;
      widget.budget.start = _startDate.millisecondsSinceEpoch;
      widget.budget.end = _endDate.millisecondsSinceEpoch;

      databaseAPI.addBudget(widget.budget);

      Navigator.pop(context);
    } else {
      print('Not added...');
    }
  }
  
}

/// State for editing an existing budget within the system.
class _EditBudgetState extends State<EditBudget> {

  final _formKey = GlobalKey<FormState>();

  static final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final formatCurrency = new NumberFormat.simpleCurrency();

  DateTime _startDate;
  DateTime _endDate;

  @override
  void initState() {
    super.initState();

    _startDate = DateTime.fromMillisecondsSinceEpoch(widget.budget.start);
    _endDate = DateTime.fromMillisecondsSinceEpoch(widget.budget.end);

    _startController.text = dateFormat.format(_startDate);
    _endController.text = dateFormat.format(_endDate);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Budget'),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: widget.budget.name,
                  decoration: InputDecoration(labelText: 'Budget Name'),
                  onSaved: (input) => setState(() => widget.budget.name = input),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Start Date:'),
                  enabled: true,
                  cursorWidth: 0,
                  controller: _startController,
                  onTap: () => _selectStartDate(context),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'End Date:'),
                  enabled: true,
                  cursorWidth: 0,
                  controller: _endController,
                  onTap: () => _selectEndDate(context),
                ),
                TextFormField(
                  initialValue: formatCurrency.format(widget.budget.amount / 100).replaceAll("\$", ""),
                  decoration: InputDecoration(labelText: 'Budget Amount'),
                  enabled: true,
                  validator: _validateAmount,
                  onSaved: (input) => setState(() => widget.budget.amount = (double.parse(input) * 100).toInt()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: _delete,
                        child: Text('Delete Budget'),
                      )
                    ),
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
        ),
      ),
    );
    
  }

  String _validateAmount(String value) {
    Pattern pattern = r'^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter valid budget amount';
    else
      return null;
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    //https://github.com/flutter/flutter/issues/7247#issuecomment-348269522
    //https://stackoverflow.com/a/44991969
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2020));

    if (picked != null) {
      print('date selected: $picked');

      setState(() => _startDate = picked);
      _startController.text = dateFormat.format(picked);
    }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    //https://github.com/flutter/flutter/issues/7247#issuecomment-348269522
    //https://stackoverflow.com/a/44991969
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2020));

    if (picked != null) {
      print('date selected: $picked');

      setState(() => _endDate = picked);
      _endController.text = dateFormat.format(picked);
    }
  }

  void _update() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.budget.start = _startDate.millisecondsSinceEpoch;
      widget.budget.end = _endDate.millisecondsSinceEpoch;
      databaseAPI.updateBudget(widget.budget);

      Navigator.pop(context);
    } else {
      print('Not updated...');
    }
  }

  void _delete() {
    databaseAPI.deleteBudget(widget.budget.id);
  }

}