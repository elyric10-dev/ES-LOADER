import 'package:es_loader/main.dart';
import "package:flutter/material.dart";
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:es_loader/dialNumbers/dialNumbers.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final TextEditingController _mobileNumberController = TextEditingController();
final TextEditingController _amountController = TextEditingController();

DialNumbers dialNumbers = DialNumbers();

String? responseMessage;
bool _isLoading = false;
bool _isDone = false;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(OWNER),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const Text("Enter Mobile Number"),
              TextField(
                controller: _mobileNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '09xxxxxxxxx'),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Enter Amount to send"),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Amount to send'),
              ),

              // CHECK GCASH BALANCE REMAINING

              ElevatedButton(
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.red,
                      )
                    : const Text('Check balance'),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    String? response =
                        await ussdQuery(dialNumbers.checkBalance);
                    debugPrint("USSD response: $response");
                    setState(() {
                      responseMessage = response;
                      _isDone = true;
                    });
                  } catch (e) {
                    debugPrint("Error: $e");
                  } finally {
                    _isLoading = false;
                  }
                },
              ),

              // SEND GCASH TO GCASH

              ElevatedButton(
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.red,
                      )
                    : const Text('Send Gcash to Gcash'),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    String query = dialNumbers.sendGcashToGcash(
                        _amountController.text,
                        "0",
                        _mobileNumberController.text);
                    String? response = await ussdQuery(query);

                    setState(() {
                      responseMessage = response;
                      _isDone = true;
                      _amountController.text = "";
                      _mobileNumberController.text = "";
                    });
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                responseMessage ?? "",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              _isDone
                  ? ElevatedButton(
                      child: const Text("Okay"),
                      onPressed: () async {
                        setState(() {
                          _isDone = false;
                          responseMessage = "";
                        });
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
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
}
