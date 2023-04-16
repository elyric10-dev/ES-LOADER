import 'package:es_loader/components/textField/customTextField.dart';
import 'package:es_loader/dialNumbers/dialNumbers.dart';
import 'package:es_loader/components/button/customButton.dart';
import 'package:flutter/material.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({
    super.key,
    required this.mobileNumberController,
    required this.amountController,
    required this.color,
  });

  final TextEditingController mobileNumberController;
  final TextEditingController amountController;
  final Color color;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool _isLoading = false;
  bool _isInsertCoin = false;
  bool _isDone = false;
  @override
  Widget build(BuildContext context) {
    DialNumbers dialNumbers = DialNumbers();
    final String mobileNumber = widget.mobileNumberController.text;
    final String amount = widget.amountController.text;
    final Color color = widget.color;
    final TextEditingController _insertCoinController = TextEditingController();

    bool isInteger(String input) {
      final regex = RegExp(r'^-?\d+$');
      return regex.hasMatch(input);
    }

    bool insertCoinCompleted() {
      if (int.parse(_insertCoinController.text) >=
          int.parse(widget.amountController.text)) {
        setState(() {
          _isLoading = false;
          _isInsertCoin = false;
          _isDone = true;
        });
        return true;
      }
      return false;
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: color,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 250.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Please Review",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Mobile number: $mobileNumber",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        "Amount: $amount.00",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextField(
                        controller: _insertCoinController,
                      ),
                    ],
                  ),

                  //SEND GCASH TO GCASH REVIEW AND INSERT COIN
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: CustomButton(
                      title: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : (insertCoinCompleted())
                              ? const Text(
                                  "Cash In",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              : Container(),
                      backgroundColor: color,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                          _isInsertCoin = true;
                        });
                        if (insertCoinCompleted()) {
                          print("COMPLETED!");
                        } else {
                          print("Insert more coins");
                        }
                      },
                    ),
                  ),

                  // INSERT COIN VALUE CHECKER
                  // if()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> ussdQuery(String code) async {
  String? response = await UssdAdvanced.sendAdvancedUssd(
    code: code,
    subscriptionId: 1,
  );
  return response;
}
