import 'package:chord_indonesia/about.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

AppBar appBar(BuildContext context, {String? title}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      "Indonesia Chord ${title == null ? "" : "- $title"}",
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    leading: Card(
      margin: const EdgeInsets.all(10),
      child: Image.asset('assets/images/logo.png'),
    ),
    actions: [
      PopupMenuButton(
        itemBuilder: (context) {
          return <PopupMenuEntry>[
            // PopupMenuItem(
            //   child: ListTile(
            //     leading: const Icon(Icons.people),
            //     title: const Text("Daftar Artist"),
            //     dense: true,
            //     onTap: () =>
            //         Navigator.of(context).popAndPushNamed("/artist-page"),
            //   ),
            // ),
            // PopupMenuItem(
            //   child: ListTile(
            //     leading: const Icon(Icons.refresh),
            //     title: const Text("Reload"),
            //     dense: true,
            //     onTap: () {
            //       // setState(() {
            //       //   chordUrl = "$CHORD_URI?r=${Random().nextInt(1000)}";
            //       // });
            //     },
            //   ),
            // ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text("Feedback"),
                dense: true,
                onTap: () async {
                  const url = "https://forms.gle/yfw1yceUhzUaBM8W6";
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.info),
                title: const Text("About"),
                dense: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.20,
                          horizontal: MediaQuery.of(context).size.width * 0.10,
                        ),
                        child: const AboutPage(),
                      );
                    },
                  );
                },
              ),
            ),
          ];
        },
      ),
    ],
    backgroundColor: Colors.red,
  );
}
