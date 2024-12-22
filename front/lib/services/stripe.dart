import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static const String _apiBase = "https://api.stripe.com/v1";
  static const String _paymentApiUrl = "$_apiBase/payment_intents";
  static const String _secretKey =
      "sk_test_51QYgSbGmNNfG4F8GviS4Ns5Yj7kfZA7dJxYqotcjlxcqZAjsIMyMEtZ49bNDdQArqD2hq9w2dhDYGrJXd89ipElX00WiwGz50U";
  static const String _publishableKey =
      "pk_test_51QYgSbGmNNfG4F8GLPTWxyz123abc456"; // Replace with your publishable key
  static final Map<String, String> _headers = {
    "Authorization": "Bearer $_secretKey",
    "Content-Type": "application/x-www-form-urlencoded",
  };

  static void init() {
    Stripe.publishableKey =
        "pk_test_51QYgSbGmNNfG4F8G8Ovzl2r0mxmrVwfZ5XLYcTGgzoXRMNFOXIAlaviTLFdyfqASbYimfxzk2mW2MZfI4rUJzQVM00i8A9lyxC";
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      final body = {
        "amount": amount,
        "currency": currency,
        "payment_method_types[]": "card",
      };

      final response = await http.post(
        Uri.parse(_paymentApiUrl),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to create payment intent: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error in createPaymentIntent: $e");
      return null;
    }
  }

  static Future<void> initPaymentSheet(String amount, String currency) async {
    try {
      final paymentIntent = await createPaymentIntent(amount, currency);
      if (paymentIntent == null) {
        throw Exception("PaymentIntent creation failed.");
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Whackiest',
        ),
      );
    } catch (e) {
      print("Error in initPaymentSheet: $e");
      rethrow;
    }
  }

  static Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print("Error in presentPaymentSheet: $e");
      rethrow;
    }
  }
}
