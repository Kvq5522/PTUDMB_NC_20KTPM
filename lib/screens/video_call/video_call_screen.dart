import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class VideoCallScreen extends StatelessWidget {
  final String conferenceID;
  final String username;
  final BigInt userId;

  const VideoCallScreen({
    super.key,
    required this.conferenceID,
    required this.username,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 420311662,
        appSign:
            "b0476b84ec3131ff865de9ef67a0297eaa59da066e81f68ef454ba9940fe2d48",
        userID: userId.toString(),
        userName: username,
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       leading: GoRouter.of(context).canPop()
  //           ? IconButton(
  //               icon: const Icon(
  //                 Icons.arrow_back_ios_rounded,
  //                 color: Colors.white,
  //               ),
  //               onPressed: () {
  //                 GoRouter.of(context).pop();
  //               },
  //             )
  //           : null,
  //       title: const Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             "Video call",
  //             style: TextStyle(color: Colors.white),
  //           )
  //         ],
  //       ),
  //       backgroundColor: const Color(0xFF008ABD),
  //       actions: [
  //         IconButton(
  //           onPressed: () {},
  //           style: ElevatedButton.styleFrom(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(2),
  //             ),
  //           ),
  //           icon: const Icon(
  //             Icons.more_vert,
  //             size: 30,
  //             color: Colors.white,
  //           ),
  //         )
  //       ],
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //       child: Column(
  //         children: [
  //           // Video player widget
  //           Expanded(
  //             flex: 5, // Chia tỉ lệ 4:6 cho phần trên và dưới
  //             child: Container(
  //               color: Colors.green, // Background color for video
  //               height: 200, // Tăng chiều cao của container
  //               child: const Center(
  //                 child: Text(
  //                   'Video will be displayed here',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 20,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           // Phần dưới: Video player widget
  //           Expanded(
  //             flex: 5,
  //             child: Container(
  //               color: const Color(0xFF008ABD), // Background color for video
  //               height: 300, // Tăng chiều cao của container
  //               child: const Center(
  //                 child: Text(
  //                   'Video will be displayed here',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 20,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 14,
  //           ),
  //           Positioned(
  //             bottom: 20,
  //             left: 0,
  //             right: 0,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 // Mute button
  //                 IconButton(
  //                   icon: Icon(Icons.mic_off),
  //                   onPressed: () {
  //                     // Handle mute action
  //                   },
  //                 ),
  //                 const SizedBox(width: 20),
  //                 // End call button
  //                 FloatingActionButton(
  //                   onPressed: () {
  //                     // Handle end call action
  //                   },
  //                   backgroundColor: const Color(0xFF008ABD),
  //                   child: const Icon(
  //                     Icons.call_end,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 20),
  //                 // Camera switch button
  //                 IconButton(
  //                   icon: const Icon(
  //                     Icons.switch_camera,
  //                   ),
  //                   onPressed: () {
  //                     // Handle camera switch action
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
