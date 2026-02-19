import 'package:flutter/material.dart';
import 'package:new_app/screens/business_detail_page.dart';

Widget buildListingCard({
  required BuildContext context,
  required String listingid,
  required String image,
  required String name,
  required String description,
  required String phone,
  required String location,
  required String ownerid,
  required String tag,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IMAGE
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  image,
                  fit: BoxFit.fill, // ✅ stretches to fill completely
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'OPEN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        // CONTENT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NAME
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    const Icon(Icons.verified, color: Colors.green, size: 14),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // DESCRIPTION (✔ FIXED)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  tag,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),

              const SizedBox(height: 10),

              // PHONE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.phone, size: 11, color: Colors.black),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // FULL WIDTH DIVIDER ✅
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 1,
                width: double.infinity,
                color: Colors.grey.shade300,
              ),

              // LOCATION + BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE8EEF5), // soft bluish background
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Color(0xFF6C8EBF), // soft blue icon
                      ),
                    ),

                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 7, color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BusinessDetailPage(
                              listingid: listingid,
                              ownerid: ownerid,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC71F37),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 6,
                        ),
                        minimumSize: const Size(60, 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.visibility, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'View',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Widget buildListingCard({
//   required BuildContext context,
//   required String image,
//   required String name,
//   required String description,
//   required String phone,
//   required String location,
// }) {
//   return SizedBox(
//     height: 350, // ✅ FIXED CARD HEIGHT
//     child: Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// IMAGE SECTION (FIXED HEIGHT)
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(
//               top: Radius.circular(8),
//             ),
//             child: Stack(
//               children: [
//                 Image.network(
//                   image,
//                   height: 150,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: const Text(
//                       'OPEN',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Icon(
//                     Icons.favorite_border,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           /// CONTENT SECTION
//           Expanded( // ✅ forces content to stay inside fixed height
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// NAME
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           name,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis, // ✅
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey[900],
//                           ),
//                         ),
//                       ),
//                       const Icon(Icons.verified,
//                           color: Colors.green, size: 16),
//                     ],
//                   ),
//
//                   const SizedBox(height: 6),
//
//                   /// DESCRIPTION (LIMITED)
//                   Text(
//                     description,
//                     maxLines: 3, // ✅ LIMIT
//                     overflow: TextOverflow.ellipsis, // ✅ ...
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Colors.black.withOpacity(0.7),
//                     ),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   /// PHONE
//                   Row(
//                     children: [
//                       Icon(Icons.phone, size: 12, color: Colors.grey[600]),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           phone,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   /// LOCATION
//                   Row(
//                     children: [
//                       Icon(Icons.location_on,
//                           size: 12, color: Colors.grey[600]),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           location,
//                           maxLines: 1, // ✅
//                           overflow: TextOverflow.ellipsis, // ✅ ...
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const Spacer(), // ✅ pushes button to bottom
//
//                   /// BUTTON
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => BusinessDetailPage(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         padding:
//                         const EdgeInsets.symmetric(vertical: 8),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                       child: const Text(
//                         'View',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
