import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoExamplesButtons extends StatelessWidget {
  const VideoExamplesButtons({
    Key? key,
  }) : super(key: key);

  static const double _iconHeight = 50;

  _launchUrl(Uri url, BuildContext context) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  _pressedTikTokButton(BuildContext context, int video_number) {
    if (video_number == 1)
      _launchUrl(Uri.parse('https://www.tiktok.com/t/ZT2abFDH4/'), context);
    else if (video_number == 2)
      _launchUrl(Uri.parse('https://www.tiktok.com/t/ZT2abLgYe/'), context);
    else if (video_number == 3)
      _launchUrl(Uri.parse('https://www.tiktok.com/t/ZT2abdqa9/'), context);
    else if (video_number == 4)
      _launchUrl(Uri.parse('https://www.tiktok.com/t/ZT2aqnBjJ/'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Spacer(),
          GestureDetector(
            onTap: () => _pressedTikTokButton(context, 1),
            child: Image.asset(
              'assets/images/tiktok.png',
              height: _iconHeight,
            ),
          ),
          const SizedBox(width: 12.5),
          GestureDetector(
            onTap: () => _pressedTikTokButton(context, 2),
            child: Image.asset(
              'assets/images/tiktok.png',
              height: _iconHeight,
            ),
          ),
          const SizedBox(width: 12.5),
          GestureDetector(
            onTap: () => _pressedTikTokButton(context, 3),
            child: Image.asset(
              'assets/images/tiktok.png',
              height: _iconHeight,
            ),
          ),
          const SizedBox(width: 12.5),
          GestureDetector(
            onTap: () => _pressedTikTokButton(context, 4),
            child: Image.asset(
              'assets/images/tiktok.png',
              height: _iconHeight,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
