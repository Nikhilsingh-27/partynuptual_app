import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/home_page.dart';

class PricingScreen extends StatefulWidget {
  final String id;

  const PricingScreen({super.key, required this.id});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  final List planslisting = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlans();
  }
  String clientid="";
  String secretid="";
  Future<void> fetchPlans() async {
    try {
      final response = await ProfileService().getplanfun();
      final details = await ProfileService().paypalcredential();
      setState(() {
        clientid=details["clientId"]??"";
        secretid=details["clientSecret"]??"";
      });
      setState(() {
        planslisting.clear();
        planslisting.addAll(response["data"]);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching plans: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Plan")),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : planslisting.isEmpty
            ? const Center(child: Text("No Plans Available"))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: planslisting.map((plan) {
                    return PricingCard(plan: plan, listingId: widget.id,clientid: clientid,          // ✅ pass here
                      secretid: secretid, );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final String listingId;
  final String clientid;
  final String secretid;
  const PricingCard({super.key, required this.plan, required this.listingId,required this.clientid,required this.secretid});

  @override
  Widget build(BuildContext context) {
    print(clientid);
    print(secretid);
    final discount = plan["discount"];
    final features = List<String>.from(plan["features"] ?? []);

    return Center(
      child: Container(
        width: 320,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// PLAN NAME
            Text(
              plan["name"] ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            /// OLD PRICE
            if (discount != null)
              Text(
                "\$${discount["original"]}",
                style: const TextStyle(
                  color: Colors.red,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 16,
                ),
              ),

            /// CURRENT PRICE
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "\$${plan["price"]}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "/ ${plan["duration"]} (Promo)",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            if (discount != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "(${discount["percent"]}% off)",
                  style: const TextStyle(fontSize: 13),
                ),
              ),

            const SizedBox(height: 16),

            /// FEATURES
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// PAY BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(
                    () => UsePaypal(
                      sandboxMode: true,
                      clientId: "Ad63rLHIXb4h-Iqf0SJ_hJPPLuCAj_IR4Ay0_2vgMQS4gsfWccc7jxeAQRanZUkDsZ_spJRaPZbPEGEc",
                      secretKey:"ENbWDdupyzCkLLXbzXgWLw5sUSaqp3BU3pUH3roQMK-aIqx5UrFhx3yEjU4N3_guIh6Xnkz1xU-EPuaX",
                      returnURL: "https://samplesite.com/return",
                      cancelURL: "https://samplesite.com/cancel",

                      transactions: [
                        {
                          "amount": {
                            "total": plan["price"].toString(),
                            "currency": "USD",
                            "details": {
                              "subtotal": plan["price"].toString(),
                              "shipping": '0',
                              "shipping_discount": 0,
                            },
                          },
                          "description": plan["name"],
                          "item_list": {
                            "items": [
                              {
                                "name": plan["name"],
                                "quantity": 1,
                                "price": plan["price"].toString(),
                                "currency": "USD",
                              },
                            ],
                          },
                        },
                      ],

                      note: "Thank you for purchasing ${plan["name"]}",

                      /// ✅ SUCCESS → Direct HomePage
                      onSuccess: (Map params) async {
                        print("onSuccess: $params");

                        // VERIFY FUNCTION COMMENTED

                        try {
                          final response = await ProfileService()
                              .verifyAndActivatePlan(
                                token: params["token"],
                                listing_id: listingId,
                                duration: plan["duration"].toString(),
                                price: plan["price"].toString(),
                                plan_id: plan["id"].toString(),
                              );

                          print("verifyAndActivatePlan response: $response");

                          // Navigate to HomePage only if response is valid
                          if (response != null &&
                              response["status"] == "true") {
                            Get.offAll(() => HomePage());
                          } else {
                            Get.snackbar("Error", "Plan verification failed");
                          }
                        } catch (e) {
                          print("Error verifying plan: $e");
                          Get.snackbar("Error", "Plan verification failed");
                        }

                        Future.delayed(const Duration(milliseconds: 300), () {
                          Get.offAll(() => HomePage());
                        });
                      },

                      /// ❌ ERROR
                      onError: (error) {
                        print("onError: $error");

                        Get.snackbar("Error", "Payment Failed");
                      },

                      /// ❌ CANCEL
                      onCancel: (params) {
                        print('cancelled: $params');

                        Get.snackbar("Cancelled", "Payment Cancelled");
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Pay Now", style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
