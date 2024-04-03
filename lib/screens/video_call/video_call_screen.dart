import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoRouter.of(context).canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
              )
            : null,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Video call",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        backgroundColor: const Color(0xFF008ABD),
        actions: [
          IconButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            icon: const Icon(
              Icons.more_vert,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Video player widget
            Expanded(
              flex: 5, // Chia tỉ lệ 4:6 cho phần trên và dưới
              child: Container(
                color: Colors.green, // Background color for video
                height: 200, // Tăng chiều cao của container
                child: const Center(
                  child: Text(
                    'Video will be displayed here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Phần dưới: Video player widget
            Expanded(
              flex: 5,
              child: Container(
                color: const Color(0xFF008ABD), // Background color for video
                height: 300, // Tăng chiều cao của container
                child: const Center(
                  child: Text(
                    'Video will be displayed here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mute button
                  IconButton(
                    icon: Icon(Icons.mic_off),
                    onPressed: () {
                      // Handle mute action
                    },
                  ),
                  const SizedBox(width: 20),
                  // End call button
                  FloatingActionButton(
                    onPressed: () {
                      // Handle end call action
                    },
                    backgroundColor: const Color(0xFF008ABD),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Camera switch button
                  IconButton(
                    icon: const Icon(
                      Icons.switch_camera,
                    ),
                    onPressed: () {
                      // Handle camera switch action
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
