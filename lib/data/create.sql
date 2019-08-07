CREATE TABLE $receiptTable (
	$id INTEGER PRIMARY KEY AUTOINCREMENT, 
	$receiptTotal INTEGER, 
	$receiptDate INTEGER
);

CREATE TABLE $budgetTable (
	id INTEGER PRIMARY KEY AUTOINCREMENT, 
    $budgetName STRING, 
    $budgetAmount INTEGER, 
	$budgetStart INTEGER, 
	$budgetEnd INTEGER, 
	$budgetProgress INTEGER
);