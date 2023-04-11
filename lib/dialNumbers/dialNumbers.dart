const String pin = "8546";

class DialNumbers {
  String checkBalance = "*143*10*10*1*$pin#";

  String sendGcashToGcash(String amount, message, mobileNumber) {
    String sendGcash = "*143*10*5*1*$amount*$message*$mobileNumber*$pin#";
    return sendGcash;
  }

  String buyRegularSimLoad(int network, amount, String mobileNumber) {
    //   Networks
    // {
    //   1 - Globe
    //   2 - TM
    //   3 - Smart
    //   4 - Sun
    //   5 - TNT
    //   6 - DITO
    //   7 - Cherry Prepaid - No available product at this moment
    //   8 - Back
    // }

    // Select type of load
    // {
    //   1 - Regular Load
    //   2 - Load Promo
    //   3 - Back
    // }

    // For Regular load
    // 1 - For Globe and TM GP Regular Load then => Amount (P10-150, 340, 550, and 900)
    // 2 - For Smart, SUN, and TNT Regular Load Denoms (P5-1000) then mobileNumber. If incorrect number. Please check mobile number or if you're using a transfered sim number from other networks then it is not compatible yet.
    // 1 - For DITO Regular Load Amount (P5-1000)

    String buyLoadQuery = "";

    // FOR TM AND GLOBE
    if (network == 1 || network == 2) {
      String buyRegularLoad =
          "*143*10*7*$network*1*1*$amount*$mobileNumber*$pin#"; //NOT DONE YET, to be TESTING pa
      buyLoadQuery = buyRegularLoad;
    }
    // FOR SMART, TNT, SUN
    if (network == 3 || network == 4 || network == 5) {
      String buyRegularLoad =
          "*143*10*7*$network*1*2*$amount*$mobileNumber*$pin#"; //NOT DONE YET, to be TESTING pa
      buyLoadQuery = buyRegularLoad;
    }
    // FOR DITO
    if (network == 6) {
      String buyRegularLoad =
          "*143*10*7*$network*1*1*$amount*$mobileNumber*$pin#"; //NOT DONE YET, to be TESTING pa
      buyLoadQuery = buyRegularLoad;
    }

    return buyLoadQuery;
  }
}
