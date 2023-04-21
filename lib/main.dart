import 'package:es_loader/helper/database_helper.dart';
import 'package:es_loader/model/inventory.dart';
import 'package:es_loader/pages/homepage/homepage.dart';
import 'package:es_loader/pages/initialpage/initialPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sql_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

const OWNER = "ES-Loader";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ES-LOADER',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return HomePage();
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Testing.com',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  bool _hasBalance = false;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
    print(_journals);
  }

  // final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _mobileNumberController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      // _titleController.text = existingJournal['title'];
      // _mobileNumberController.text = existingJournal['description'];
    }

    // showModalBottomSheet(
    //     context: context,
    //     elevation: 5,
    //     isScrollControlled: true,
    //     builder: (_) => Container(
    //           padding: EdgeInsets.only(
    //             top: 15,
    //             left: 15,
    //             right: 15,
    //             // this will prevent the soft keyboard from covering the text fields
    //             bottom: MediaQuery.of(context).viewInsets.bottom + 120,
    //           ),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             children: [
    //               // TextField(
    //               //   controller: _titleController,
    //               //   decoration: const InputDecoration(hintText: 'Title'),
    //               // ),
    //               // const SizedBox(
    //               //   height: 10,
    //               // ),
    //               // TextField(
    //               //   controller: _mobileNumberController,
    //               //   decoration: const InputDecoration(hintText: 'Description'),
    //               // ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               ElevatedButton(
    //                 onPressed: () async {
    //                   // Save new journal
    //                   if (id == null) {}

    //                   // if (id != null) {
    //                   //   await _updateItem(id);
    //                   // }

    //                   // // Clear the text fields
    //                   // _titleController.text = '';
    //                   // _mobileNumberController.text = '';

    //                   // Close the bottom sheet
    //                   Navigator.of(context).pop();
    //                 },
    //                 child: Text(id == null ? 'Create New' : 'Update'),
    //               )
    //             ],
    //           ),
    //         ));
  }

// INSERT OR CREATE NEW INVENTORY AND USER BALANCE
  Future<void> _addItem() async {
    final latestGcashBalance = await SQLHelper.getGcashBalance();

    int currentGcashBalance = latestGcashBalance[0]['new_gcash_balance'];
    String mobile = "09912046698";
    int loadAmount = 50;
    int fee = 5;
    int totalPayment = loadAmount + fee;
    int newGcashBalance = currentGcashBalance - loadAmount;
    int userInserted = 55;
    String transacId = currentGcashBalance.toString() +
        mobile +
        loadAmount.toString() +
        fee.toString() +
        totalPayment.toString() +
        userInserted.toString();
    int userBalance = userInserted - totalPayment;

    setState(() {
      (userInserted > totalPayment) ? _hasBalance = true : _hasBalance = false;
    });

    Inventory data = Inventory(
      currentBalance: currentGcashBalance,
      mobileNumber: mobile,
      deductBalance: loadAmount,
      fee: fee,
      totalProfit: totalPayment,
      newBalance: newGcashBalance,
      inserted: userInserted,
      numberBalance: userBalance,
      timestamp: DateTime.now(),
      transactionId: transacId,
      hasEnquired: 0,
      enquiryFixed: 0,
    );
    await SQLHelper.createItem(data).then((value) async {
      final checkNumber = await SQLHelper.getBalanceByNumber(mobile);
      if (checkNumber.isNotEmpty && _hasBalance) {
        final int cashBalance = checkNumber[0]['cash_balance'];
        final int newCashBalance = cashBalance + userBalance;

        await SQLHelper.updateUserBalance(mobile, newCashBalance);
        print(
            "P$userBalance.00 was added to your balance. You have a total of P$newCashBalance.00 balance");
      } else if (checkNumber.isEmpty && _hasBalance) {
        await SQLHelper.createUserBalance(mobile, userBalance);
        print(
            "Don't worry with your P$userBalance.00 pesos balance, you can use it whenever you load again");
      }
      _refreshJournals();
    });
  }

  // // Update an existing journal
  // Future<void> _updateItem(int id) async {
  //   await SQLHelper.updateItem(
  //       id, _titleController.text, _mobileNumberController.text);
  //   _refreshJournals();
  // }

  // // Delete an item
  // void _deleteItem(int id) async {
  //   await SQLHelper.deleteItem(id);
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //     content: Text('Successfully deleted a journal!'),
  //   ));
  //   _refreshJournals();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing.com'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                  color: Colors.orange[200],
                  margin: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Id")),
                        DataColumn(label: Text("New Gcash Balance")),
                        DataColumn(label: Text("Current Gcash Balance")),
                        DataColumn(label: Text("Mobile Number")),
                        DataColumn(label: Text("Load Amount")),
                        DataColumn(label: Text("Fee")),
                        DataColumn(label: Text("Total Amount")),
                        DataColumn(label: Text("Inserted")),
                        DataColumn(label: Text("Number Balance")),
                        DataColumn(label: Text("Timestamp")),
                        DataColumn(label: Text("Transaction Id")),
                        DataColumn(label: Text("Has Enquired")),
                        DataColumn(label: Text("Enquiry Fixed")),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text(
                            _journals[index]['id'].toString(),
                          )),
                          DataCell(Text(
                            _journals[index]['new_gcash_balance'].toString(),
                          )),
                          DataCell(Text(
                            _journals[index]['current_gcash_balance']
                                .toString(),
                          )),
                          DataCell(Text(
                            _journals[index]['mobile_number'],
                          )),
                          DataCell(Text(
                            _journals[index]['deduct_balance'].toString(),
                          )),
                          DataCell(Text(
                            _journals[index]['fee'].toString(),
                          )),
                          DataCell(Text(
                            _journals[index]['total_profit'].toString(),
                          )),
                          DataCell(Text(
                            _journals[index]['inserted'].toString(),
                          )),
                          DataCell(Text(
                            _journals[index]['number_balance'].toString(),
                          )),
                          DataCell(Text(
                            _journals[index]['timestamp'].toString(),
                          )),
                          DataCell(Text(
                            _journals[index]['transaction_id'],
                          )),
                          DataCell(Text(
                            _journals[index]['has_enquired'].toString(),
                          )),
                          DataCell(Text(
                            _journals[index]['enquire_fixed'].toString(),
                          )),
                        ])
                      ],
                    ),
                  )),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await _addItem();
        },
      ),
    );
  }
}
