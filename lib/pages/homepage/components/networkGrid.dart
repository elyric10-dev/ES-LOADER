import 'package:es_loader/pages/initialPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:es_loader/components/button/customButton.dart';
import 'package:es_loader/components/textField/customTextField.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class NetworkGrid extends StatefulWidget {
  NetworkGrid({
    super.key,
    required List<Map<String, dynamic>> gridItems,
  }) : _gridItems = gridItems;

  final List<Map<String, dynamic>> _gridItems;
  @override
  State<NetworkGrid> createState() => _NetworkGridState();
}

class _NetworkGridState extends State<NetworkGrid> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _insertCoinController = TextEditingController();

  bool _isReview = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: widget._gridItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          mainAxisExtent: 90,
        ),
        itemBuilder: (context, index) {
          final item = widget._gridItems[index];

          // CLICKING NETWORKS
          return GestureDetector(
            onTap: () {
              modalBottom(context, item);
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lime, width: 0.8),
                gradient: const LinearGradient(
                  colors: [Colors.white24, Colors.white38],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(item["logo"]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> modalBottom(BuildContext context, Map<String, dynamic> item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        final String mobileNumber = _mobileNumberController.text;
        final String amount = _amountController.text;
        final String insertCoin = _insertCoinController.text;
        int? insertedCoin;
        bool filledUpInput() {
          return (mobileNumber.length == 11 && amount.isNotEmpty)
              ? true
              : false;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              _isReview
                  ? "Please Review and Insert coin or bill if ready"
                  : item['title'],
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
                child: Column(
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
                            child: _isReview
                                ? Text(
                                    "Mobile number: $mobileNumber",
                                    style: const TextStyle(
                                      fontSize: 23,
                                    ),
                                  )
                                : CustomTextField(
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
                                  ? _isReview
                                      ? Text(
                                          "Amount: P$amount.00",
                                          style: const TextStyle(
                                            fontSize: 23,
                                          ),
                                        )
                                      : CustomTextField(
                                          controller: _amountController,
                                          color: item['color'],
                                          hint: "Amount",
                                        )
                                  : Container()),
                          _isReview
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 250.0,
                                  ),
                                  child: CustomTextField(
                                      controller: _insertCoinController,
                                      onChange: (value) {
                                        if (value.isEmpty) {
                                          insertedCoin = null;
                                        } else {
                                          insertedCoin = int.tryParse(value);
                                        }
                                        print(insertedCoin);
                                        if (insertedCoin != null &&
                                            insertedCoin! >=
                                                int.parse(amount)) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        } else {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                        }
                                      },
                                      color: item['color'],
                                      hint: "Insert Coin"),
                                )
                              : Container(),
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
                                  // FOR REGULAR AND PROMO
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 50.0),
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
                                  : !_isReview
                                      ? CustomButton(
                                          title: const Text(
                                            "Review",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          backgroundColor: filledUpInput()
                                              ? item['color']
                                              : Colors.grey,
                                          onPressed: () {
                                            filledUpInput()
                                                ? setState(() {
                                                    _isReview = true;
                                                    _isLoading = true;
                                                    modalBottom(context, item);
                                                  })
                                                : '';
                                          },
                                        )
                                      : _isReview
                                          ? _isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator())
                                              : CustomButton(
                                                  title: const Text(
                                                    "Cash In",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      item['color'],
                                                  onPressed: () async {
                                                    setState(() {
                                                      _isReview = true;
                                                      _isLoading = true;
                                                      modalBottom(
                                                          context, item);
                                                    });
                                                    String? successResponse =
                                                        "Thank you for using ES-Loader, please comeback again ❤️.";

                                                    String? errorResponse =
                                                        "Currently do not have enough balance to send money🥲.";
                                                    String?
                                                        detectErrorResponse =
                                                        "You do not have enough balance to send money.";

                                                    try {
                                                      String query = dialNumbers
                                                          .sendGcashToGcash(
                                                              _amountController
                                                                  .text,
                                                              "0",
                                                              _mobileNumberController
                                                                  .text);
                                                      await ussdQuery(query)
                                                          .then(
                                                        (value) {
                                                          setState(() {
                                                            _isLoading = true;
                                                            modalBottom(
                                                                context, item);
                                                          });
                                                          if (value!.contains(
                                                              detectErrorResponse)) {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    "Insufficient Balance",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25),
                                                                  ),
                                                                  content: Text(
                                                                    errorResponse,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      child:
                                                                          const Text(
                                                                        "Okay",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                22),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context).popUntil((route) =>
                                                                            route.isFirst);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    "Successfully Cashed in!",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25),
                                                                  ),
                                                                  content: Text(
                                                                    successResponse,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      child:
                                                                          const Text(
                                                                        "Okay",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                22),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context).popUntil((route) =>
                                                                            route.isFirst);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    } catch (e) {
                                                      print(e);
                                                    } finally {
                                                      setState(() {
                                                        _isLoading = false;
                                                        _isReview = false;
                                                        _mobileNumberController
                                                            .text = '';
                                                        _amountController.text =
                                                            '';
                                                        _insertCoinController
                                                            .text = '';
                                                      });
                                                    }
                                                  },
                                                )
                                          : const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator())),
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
}

Future<String?> ussdQuery(String code) async {
  String? successResponse = await UssdAdvanced.sendAdvancedUssd(
    code: code,
    subscriptionId: 1,
  );
  return successResponse;
}
