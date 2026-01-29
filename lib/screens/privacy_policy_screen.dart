import 'package:flutter/material.dart';
import 'package:new_app/screens/widgets/bottom.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔹 CONTENT SECTION
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _heading("Personal Information We Collect"),
                  _bodyText(
                      "When you visit the Site, we automatically collect certain information about your device, "
                          "including information about your web browser, IP address, time zone, and some of the cookies "
                          "that are installed on your device."
                  ),

                  _bodyText(
                      "Additionally, as you browse the Site, we collect information about the individual web pages or "
                          "products that you view, what websites or search terms referred you to the Site, and information "
                          "about how you interact with the Site. We refer to this information as “Device Information.”"
                  ),

                  _subHeading("We collect Device Information using the following technologies:"),

                  _boldText("Cookies"),
                  _bodyText(
                      "are data files that are placed on your device or computer and often include an anonymous unique identifier. "
                          "For more information about cookies, visit http://www.allaboutcookies.org."
                  ),

                  _boldText("Log files"),
                  _bodyText(
                      "track actions occurring on the Site, and collect data including your IP address, browser type, "
                          "Internet service provider, referring/exit pages, and date/time stamps."
                  ),

                  _boldText("Web beacons, tags, and pixels"),
                  _bodyText(
                      "are electronic files used to record information about how you browse the Site."
                  ),

                  _heading("Order Information"),
                  _bodyText(
                      "When you make a purchase or attempt to make a purchase through the Site, we collect certain "
                          "information from you, including your name, billing address, shipping address, payment information, "
                          "email address, and phone number. We refer to this information as “Order Information.”"
                  ),

                  _bodyText(
                      "When we talk about “Personal Information” in this Privacy Policy, we are talking both about "
                          "Device Information and Order Information."
                  ),

                  _heading("How Do We Use Your Personal Information?"),
                  _bodyText(
                      "We use the Order Information that we collect generally to fulfill any orders placed through the Site "
                          "(including processing your payment information, arranging for shipping, and providing invoices or order confirmations)."
                  ),

                  _bullet("Communicate with you"),
                  _bullet("Screen orders for potential risk or fraud"),
                  _bullet("Provide information or advertising relating to our products or services"),

                  _bodyText(
                      "We use Device Information to help us screen for potential risk and fraud and to improve and optimize our Site."
                  ),

                  _heading("Sharing Your Personal Information"),
                  _bodyText(
                      "We share your Personal Information with third parties to help us use your Personal Information, "
                          "such as analytics and payment processing services."
                  ),

                  _bodyText(
                      "We may also share your Personal Information to comply with applicable laws and regulations or "
                          "to respond to lawful requests."
                  ),

                  _heading("Behavioural Advertising"),
                  _bodyText(
                      "We use your Personal Information to provide you with targeted advertisements or marketing communications."
                  ),

                  _bodyText(
                      "You can opt out of targeted advertising by visiting: http://optout.aboutads.info/"
                  ),

                  _heading("Do Not Track"),
                  _bodyText(
                      "Please note that we do not alter our Site’s data collection and use practices when we see a Do Not Track signal."
                  ),

                  _heading("Your Rights"),
                  _bodyText(
                      "If you are a European resident, you have the right to access personal information we hold about you "
                          "and to ask that your personal information be corrected, updated, or deleted."
                  ),

                  _heading("Data Retention"),
                  _bodyText(
                      "When you place an order through the Site, we will maintain your Order Information unless you ask us to delete it."
                  ),

                  _heading("Minors"),
                  _bodyText(
                      "The Site is not intended for individuals under the age of 18."
                  ),

                  _heading("Changes"),
                  _bodyText(
                      "We may update this privacy policy from time to time to reflect changes to our practices."
                  ),

                  _heading("Contact Us"),
                  _bodyText(
                      "If you have any questions about this Privacy Policy, please contact us at:\n\n"
                          "partynuptual@partynuptual.com"
                  ),


                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 BOTTOM SECTION (FULL WIDTH)
            BottomSection(),
          ],
        ),
      ),
    );
  }

  // ---------------- STYLES ----------------

  Widget _heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _subHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _boldText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _bodyText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, height: 1.5),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• "),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
