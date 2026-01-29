import 'package:flutter/material.dart';
import 'package:new_app/screens/widgets/bottom.dart';

class TermScreen extends StatefulWidget {
  const TermScreen({super.key});

  @override
  State<TermScreen> createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
      ),
      body: SingleChildScrollView(

        child: Column(

          children: [
            Padding(padding: EdgeInsets.all(8),
            child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                _bodyText(
                    "Please read these terms and conditions carefully before using Our Service."
                ),

                _heading("Interpretation and Definitions"),
                _subHeading("Interpretation"),
                _bodyText(
                    "The words of which the initial letter is capitalized have meanings defined under the following conditions. "
                        "The following definitions shall have the same meaning regardless of whether they appear in singular or in plural."
                        "The Service is protected by copyright, trademark, and other laws of both the Country and foreign countries."

                    "Our trademarks and trade dress may not be used in connection with any product or service without the prior written consent of the Company."
                ),

                _subHeading("Definitions"),
                _bodyText("For the purposes of these Terms and Conditions:"),

                _boldText("Affiliate"),
                _bodyText(
                    "means an entity that controls, is controlled by or is under common control with a party, "
                        "where \"control\" means ownership of 50% or more of the shares, equity interest or other securities entitled "
                        "to vote for election of directors or other managing authority."
                ),

                _boldText("Account"),
                _bodyText(
                    "means a unique account created for You to access our Service or parts of our Service."
                ),

                _boldText("Country"),
                _bodyText("refers to: New York, United States"),

                _boldText("Service"),
                _bodyText("refers to the Website."),

                _boldText("Terms and Conditions"),
                _bodyText(
                    "(also referred as \"Terms\") mean these Terms and Conditions that form the entire agreement between You "
                        "and the Company regarding the use of the Service."
                ),

                _boldText("Third-party Social Media Service"),
                _bodyText(
                    "means any services or content (including data, information, products or services) provided by a third-party "
                        "that may be displayed, included or made available by the Service."
                ),

                _boldText("Website"),
                _bodyText(
                    "refers to partynuptual, accessible from partynuptual.com"
                ),

                _boldText("You"),
                _bodyText(
                    "means the individual accessing or using the Service, or the company, or other legal entity on behalf "
                        "of which such individual is accessing or using the Service."
                ),

                _heading("Acknowledgment"),
                _bodyText(
                    "These are the Terms and Conditions governing the use of this Service and the agreement that operates "
                        "between You and the Company."
                ),

                _bodyText(
                    "Your access to and use of the Service is conditioned on Your acceptance of and compliance with these "
                        "Terms and Conditions."
                ),

                _bodyText(
                    "By accessing or using the Service You agree to be bound by these Terms and Conditions."
                ),

                _bodyText(
                    "You represent that you are over the age of 18. The Company does not permit those under 18 to use the Service."
                ),

                _heading("User Accounts"),
                _bodyText(
                    "When You create an account with Us, You must provide information that is accurate, complete, and current."
                ),

                _bodyText(
                    "You are responsible for safeguarding the password and for all activities under Your account."
                ),

                _heading("Intellectual Property"),
                _bodyText(
                    "The Service and its original content, features and functionality are and will remain the exclusive "
                        "property of the Company and its licensors."
                ),

                _heading("Links to Other Websites"),
                _bodyText(
                    "Our Service may contain links to third-party web sites or services that are not owned or controlled "
                        "by the Company."
                ),

                _heading("Termination"),
                _bodyText(
                    "We may terminate or suspend Your Account immediately, without prior notice or liability, for any reason."
                ),

                _heading("Limitation of Liability"),
                _bodyText(
                    "To the maximum extent permitted by applicable law, the Company shall not be liable for any indirect, "
                        "incidental, or consequential damages."
                ),

                _heading("\"AS IS\" and \"AS AVAILABLE\" Disclaimer"),
                _bodyText(
                    "The Service is provided to You \"AS IS\" and \"AS AVAILABLE\" without warranty of any kind."
                ),

                _heading("Governing Law"),
                _bodyText(
                    "The laws of the Country shall govern this Terms and Your use of the Service."
                ),

                _heading("Disputes Resolution"),
                _bodyText(
                    "If You have any concern or dispute about the Service, You agree to first try to resolve the dispute "
                        "informally by contacting the Company."
                ),

                _heading("Changes to These Terms and Conditions"),
                _bodyText(
                    "We reserve the right to modify or replace these Terms at any time."
                ),

                _heading("Contact Us"),
                _bodyText(
                    "If you have any questions about these Terms and Conditions, You can contact us by email:\n\n"
                        "partynuptual@partynuptual.com"
                ),

              ],
            )
            ),

            const SizedBox(height: 24),

            BottomSection(),
          ],
        ),
      ),
    );
  }

  // ------------------ TEXT STYLES ------------------

  Widget _heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _subHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _boldText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _bodyText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: const TextStyle(
          height: 1.5,
          fontSize: 14,
        ),
      ),
    );
  }
}
