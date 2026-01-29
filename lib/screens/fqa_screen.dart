import 'package:flutter/material.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/faq.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  final List<FAQItem> vendorsFAQ = const [
    FAQItem(
      question: "How will you Promote my Business?",
      answer:
      "We advertise & promote your Business using common online tools with our expertise. We work on all Social Media Platform, Google listing, Google Adwords, Email marketing, Blog submissions, Articles, Press releases, and much more.",
    ),
    FAQItem(
      question: "How Vendors will get a lot of Customers?",
      answer:
      "We'll provide all of our Vendors with worldwide exposure where you can deal with your clients and collect Payments directly .",
    ),
    FAQItem(
      question: "How long you're in Business?",
      answer:"It's Been Years Since we are Catering Hospitality Industry to provide Top-Notch Services. Party Nuptual Network is not just a Business for us, we are into organising, planning 360* degre , 24/7 Serving Platform to Vendors & Clients.",
    ),
    FAQItem(
      question: "Who will do my Listing Job?",
      answer:"Listing with Party Nuptual is a one-minute process to Showcase your Business online and to get the Potential Prospects or our customers service executives will create a listing on your behalf.",
    ),
    FAQItem(
      question: "Is there any contract or commission/hidden charges?",
      answer:"No.",
    ),
    FAQItem(
      question: "How much is the Fee for the Subscription? Where are you located?",
      answer:"Monthy Fees is 9.99  USD / Busines Listing Expires after 28 days . Party Nuptual Network is a US Based Company and our sales team works from India, Asia & Dubai. I'm sure you are perhaps absolutely looking for more gigs for showing off your talent.",
    ),

  ];

  final List<FAQItem> customersFAQ = const [
    FAQItem(
      question: "How we can check the legitimacy of the vendors?",
      answer:
      "You can check the legitimacy of the Vendors by Checking Reviews are you can asked to see some of there past work.",
    ),
    FAQItem(
      question: "How do we make the payments?",
      answer:
      "Payments you make directly to Vendors, Party Nuptual Network is just a Platform for Vendors and their Clients. However, We are not responsible for any Business Transactions Between Venders and their Clients.",
    ),
    FAQItem(
      question: "Do you running any discounts?",
      answer:"Great! Discounts is totally your negotitation with the vendors.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
        
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    FAQWidget(title: "Vendors FAQ", items: vendorsFAQ),
                    const SizedBox(height: 24),
                    FAQWidget(title: "Customers FAQ", items: customersFAQ),
                  ],
                ),
              ),
              BottomSection(),
        
            ],
          ),
        ),
      ),
    );
  }
}
