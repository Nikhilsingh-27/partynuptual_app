import 'package:flutter/material.dart';
import 'package:new_app/screens/widgets/bottom.dart';


class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Disclaimer"),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _heading("Disclaimer for Party Nuptual Group LLC"),

                      _bodyText(
                          "If you require any more information or have any questions about our site's disclaimer, "
                              "please feel free to contact us by email at partynuptual@partynuptual.com."
                      ),

                      _subHeading("Disclaimers for partynuptual.com"),

                      _bodyText(
                          "All the information on this website - https://www.partynuptual.com/ - is published in good faith "
                              "and for general information purpose only. partynuptual.com does not make any warranties about "
                              "the completeness, reliability and accuracy of this information. Any action you take upon the information "
                              "you find on this website (partynuptual.com), is strictly at your own risk. partynuptual.com will not be "
                              "liable for any losses and/or damages in connection with the use of our website."
                      ),

                      _bodyText(
                          "From our website, you can visit other websites by following hyperlinks to such external sites. "
                              "While we strive to provide only quality links to useful and ethical websites, we have no control over the content and nature of these sites. These links to other websites do not imply a recommendation for all the content found on these sites. Site owners and content may change without notice and may occur before we have the opportunity to remove a link which may have gone bad."

                      ),
                      _bodyText("Please be also aware that when you leave our website, other sites may have different privacy policies and terms which are beyond our control. Please be sure to check the Privacy Policies of these sites as well as their Terms of Service before engaging in any business or uploading any information."),
                      _heading("Covid-19"),
                      _bodyText("Party Nuptual Group LLC is not liable for any Covid-19 infection. Customers and Vendors must wear a mask or face covering when doing any business transaction. Customers and Vendors must practice social distancing and stay at least 6 feet away from each other. Vendors must disinfect and clean its premises with more frequent cleaning of high touched surfaces."),
                      _heading("Consent"),
                      _bodyText("By using our website, you hereby consent to our disclaimer and agree to its terms."),
                      _heading("Update"),
                      _bodyText("Should we update, amend or make any changes to this document, those changes will be prominently posted here."),
                    ],
                  ),

                ),
                SizedBox(height: 20,),
                BottomSection(),
              ],
            )

        )
    );
  }

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