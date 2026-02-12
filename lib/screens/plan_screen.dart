import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:new_app/data/services/profile_service.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

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

  Future<void> fetchPlans() async {
    try {
      final response = await ProfileService().getplanfun();

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
                    return PricingCard(plan: plan);
                  }).toList(),
                ),
              ),
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final Map<String, dynamic> plan;

  const PricingCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
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

            /// OLD PRICE (if discount exists)
            if (discount != null)
              Text(
                "\$${discount["original"]}",
                style: const TextStyle(
                  color: Colors.red,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 16,
                ),
              ),

            /// CURRENT PRICE + DURATION
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

            /// DISCOUNT PERCENT
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsePaypal(
                        sandboxMode: true, // change to false for live
                        clientId: "YOUR_CLIENT_ID",
                        secretKey: "YOUR_SECRET_KEY",

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

                        onSuccess: (Map params) async {
                          print("onSuccess: $params");

                          try {
                            final response = await ProfileService()
                                .verifyAndActivatePlan(
                                  planId: plan["id"].toString(),
                                  paymentId: params["paymentId"] ?? "",
                                );

                            Navigator.pop(context);

                            if (response["success"] == true) {
                              Get.snackbar(
                                "Success",
                                "Plan Activated Successfully",
                              );
                            } else {
                              Get.snackbar(
                                "Error",
                                "Payment verification failed",
                              );
                            }
                          } catch (e) {
                            Navigator.pop(context);
                            Get.snackbar("Error", "Server Error");
                          }
                        },

                        onError: (error) {
                          print("onError: $error");
                          Navigator.pop(context);
                          Get.snackbar("Error", "Payment Failed");
                        },

                        onCancel: (params) {
                          print('cancelled: $params');
                          Navigator.pop(context);
                          Get.snackbar("Cancelled", "Payment Cancelled");
                        },
                      ),
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
