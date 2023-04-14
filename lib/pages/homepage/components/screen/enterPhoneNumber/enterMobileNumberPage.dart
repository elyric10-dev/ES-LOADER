import 'package:es_loader/components/button/customButton.dart';
import 'package:es_loader/components/textField/customTextField.dart';
import 'package:es_loader/dialNumbers/dialNumbers.dart';
import 'package:flutter/material.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

Future<dynamic> EnterMobileNumberPage(
    BuildContext context, Map<String, dynamic> item) {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DialNumbers dialNumbers = DialNumbers();
  bool _isLoading = false;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            item['title'],
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: item['color'],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 250.0,
                            right: 250.0,
                            top: 30.0,
                            bottom: 0.0,
                          ),
                          child: CustomTextField(
                            controller: _mobileNumberController,
                            color: item['color'],
                            hint: "09xxxxxxxxx",
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                              left: 250.0,
                              right: 250.0,
                              top: 15.0,
                              bottom: 30.0,
                            ),
                            child: (!item['forSimLoad'])
                                ? CustomTextField(
                                    controller: _amountController,
                                    color: item['color'],
                                    hint: "Amount",
                                  )
                                : Container()),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .42,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              item['logo'],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: (item['forSimLoad'])
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 50.0),
                                      child: CustomButton(
                                        title: const Text(
                                          "Regular",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        backgroundColor: item['color'],
                                        onPressed: () {
                                          print("REGULAR");
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 50.0),
                                      child: CustomButton(
                                        title: const Text(
                                          "Promo",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        backgroundColor: item['color'],
                                        onPressed: () {
                                          print("PROMO");
                                        },
                                      ),
                                    )
                                  ],
                                )
                              : CustomButton(
                                  title: const Text(
                                    "Review",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  backgroundColor: item['color'],
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        final mobilenumber =
                                            _mobileNumberController.text;
                                        final amount = _amountController.text;
                                        return Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                              child: Text(
                                                "Please Review",
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10.0),
                                                  child: Text(
                                                    "Mobile number: $mobilenumber",
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Amount: $amount.00",
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            //SEND GCASH TO GCASH
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20.0),
                                              child: CustomButton(
                                                  title: _isLoading
                                                      ? const CircularProgressIndicator(
                                                          color: Colors.red,
                                                        )
                                                      : const Text(
                                                          "Cash In",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                  backgroundColor:
                                                      item['color'],
                                                  onPressed: () async {
                                                    _isLoading = true;
                                                    try {
                                                      String query = dialNumbers
                                                          .sendGcashToGcash(
                                                              _amountController
                                                                  .text,
                                                              "0",
                                                              _mobileNumberController
                                                                  .text);
                                                      String? response =
                                                          await ussdQuery(
                                                              query);
                                                    } catch (e) {
                                                      print(e);
                                                    } finally {
                                                      _isLoading = false;
                                                    }
                                                  }),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      );
    },
  );
}
// USSD QUERY

Future<String?> ussdQuery(String code) async {
  String? response = await UssdAdvanced.sendAdvancedUssd(
    code: code,
    subscriptionId: 1,
  );
  return response;
}
