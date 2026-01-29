import 'package:flutter/material.dart';

class PricingScreen extends StatelessWidget {
  PricingScreen({super.key});

  final List<Map<String, dynamic>> plans = [
    {
      "duration": "Month",
      "price": "\$9.99",
      "oldPrice": null,
      "discount": null,
    },
    {
      "duration": "3 Months",
      "price": "\$28.47",
      "oldPrice": "\$29.97",
      "discount": "5% off",
    },
    {
      "duration": "6 Months",
      "price": "\$53.94",
      "oldPrice": "\$59.94",
      "discount": "10% off",
    },
    {
      "duration": "12 Months",
      "price": "\$95.6",
      "oldPrice": "\$119.88",
      "discount": "20% off",
    },
  ];

  final List<String> features = [
    "Unlimited Customer’s",
    "Unlimited Direct Booking’s",
    "Unlimited Photograph’s",
    "Social media Links",
    "Business Promotions",
    "Video Links",
    "Business Branding",
    "No Contract or Obligation",
    "No Yearly Fess",
    "No Hidden Charges",
    "Email Contact Form",
    "Admin Panel",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Your Plan"),),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: plans.map((plan) {
                  return PricingCard(
                    plan: plan,
                    features: features,
                  );
                }).toList(),
              ),
            ),


          )
      )
    );
  }
}

class PricingCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final List<String> features;

  const PricingCard({
    super.key,
    required this.plan,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Container(
        width: 300,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            /// TITLE
            const Text(
              "PARTY NUPTUAL\nNETWORK",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            /// PRICE
            if (plan["oldPrice"] != null)
              Text(
                plan["oldPrice"],
                style: const TextStyle(
                  color: Colors.red,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 16,
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  plan["price"],
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "/ ${plan["duration"]}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            if (plan["discount"] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "(${plan["discount"]})",
                  style: const TextStyle(fontSize: 13),
                ),
              ),

            const SizedBox(height: 16),

            /// FEATURES
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((f) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    f,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),



            /// PAY BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Pay Now",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );

  }
}
