import 'package:flutter/material.dart';
import 'package:new_app/screens/widgets/bottom.dart';
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'About Party Nuptual',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Padding(padding: const EdgeInsets.only(left: 15,right: 15),
              child: Column(
                children: [

                  _Paragraph(
                    text:
                    "Party Nuptual, based in Brooklyn, NY, serves as a comprehensive event planning platform catering to a diverse array of celebrations. They excel in connecting clients with various event services including, but not limited to, party clowns, entertainers, event planners, dancers, and decorators, making the event planning process hassle-free and enjoyable. Whether it's a birthday bash or a grand wedding celebration, Party Nuptual aims to bring unique and personalized experiences to each event. Their extensive network of professional service providers ensures that every aspect of an event is meticulously planned and executed, turning envisioned ideas into cherished memories. Through a blend of professionalism, creativity, and a keen understanding of client preferences, Party Nuptual aspires to elevate every celebration into a memorable affair.",
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                      text:
                      "Party Nuptual is our ultimate destination for exceptional event planning. We are a comprehensive, 360-degree, 24/7 service platform for vendors and clients alike. We specialize in connecting clients with a diverse range of event services, making the planning of any event, from birthday bashes to holiday parties to large-scale weddings, hassle-free and fun. We aim to provide consumers with the events of their dreams with high-quality services that match any budget."
                  ),

                  SizedBox(height: 24),
                  _Paragraph(text: "Our extensive network of professional service providers amplifies the visibility of freelancers and small businesses in various sectors, including event planners, photographers, musicians, dancers, decorators, and many more. We strive to generate opportunities and create employment with a mission to support an estimated 3.5 billion freelancers worldwide over the next decade."),
                  SizedBox(height: 20),
                  _Paragraph(text: "Join us at Party Nuptual to become part of an innovative network that transforms events into memorable affairs."),
                  SizedBox(height: 24,),
                  _SectionTitle(title: 'Kevin Fraser Bio'),
                  SizedBox(height: 10),
                  _Paragraph(text: "Kevin Fraser moved to the United States at the age of 16. After graduating from High School, he secured a position as a security officer with Universal Music Group. It was during this time that he conceived the idea for the Party Nuptual Network right from his security desk. Party Nuptual Network was created not only to help existing large companies but to amplify the visibility of freelancers and small businesses across various sectors, including photographers, makeup artists, barbers, party hosts, and food vendors. The overarching mission of the Party Nuptual Network is to generate opportunities, aiming to create employment for an estimated 3.5 billion freelancers worldwide over the next decade."),
                  SizedBox(height: 10),
                ],
              )
            ),
            /// About Section

            BottomSection()

          ],
        ),


      ),
    );
  }
}

/// ------------------
/// Reusable Widgets
/// ------------------

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;

  const _Paragraph({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.5,
        color: Colors.black54,
      ),
    );
  }
}
