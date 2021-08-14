library rrad_otp_client;

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class RRADOTP {
  static final RRADOTP _singleton = RRADOTP._internal();
  factory RRADOTP() {
    return _singleton;
  }
  RRADOTP._internal();

  initialize(ParseCoreData serverData) async {
    await Parse().initialize(
      serverData.applicationId,
      serverData.serverUrl,
      clientKey: serverData.clientKey,
    );
  }

  Future<bool> sendOtp(String phoneNumber) async {
    bool _otpStatus = false;
    ParseCloudFunction _sendOtp = ParseCloudFunction('SendOtp');
    ParseResponse response = await _sendOtp.execute(parameters: {
      'phoneNumber': phoneNumber,
    });
    if (response.success && response.result != null) {
      _otpStatus = response.result;
    }
    return Future.value(_otpStatus);
  }

  Future<bool> matchOtp(UserCredential userCredential) async {
    bool _otpStatus = false;
    ParseCloudFunction _sendOtp = ParseCloudFunction('MatchOtp');
    ParseResponse response = await _sendOtp.execute(parameters: {
      'phoneNumber': userCredential.phoneNumber,
      'otp': userCredential.otp,
    });
    if (response.success && response.result != null) {
      _otpStatus = response.result;
    }
    return Future.value(_otpStatus);
  }
}

class UserCredential {
  String phoneNumber;
  String otp;
  UserCredential({
    required this.phoneNumber,
    required this.otp,
  });
}
