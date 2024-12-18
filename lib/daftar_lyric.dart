import 'package:chord_indonesia/app_bar.dart';
import 'package:chord_indonesia/apps.dart';
import 'package:chord_indonesia/constant_variable.dart';
import 'package:chord_indonesia/helper.dart';
import 'package:chord_indonesia/model/artist.dart';
import 'package:chord_indonesia/model/lyric_header.dart';
import 'package:flutter/material.dart';

class DaftarLirikPage extends StatefulWidget {
  const DaftarLirikPage({super.key, this.artist});
  final Artist? artist;
  static const String routeName = '/daftar-lirik';

  @override
  State<DaftarLirikPage> createState() => _DaftarLirikPageState();
}

class _DaftarLirikPageState extends State<DaftarLirikPage> {
  bool isLoading = true;
  List<LyricHeader> lyricHeaderList = [];

  @override
  void initState() {
    super.initState();

    getLyricHeader(widget.artist?.url).then((value) {
      setState(() {
        lyricHeaderList = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: appBar(context, title: widget.artist?.name),
          body: Column(
            children: [
              Visibility(
                  visible: isLoading, child: const LinearProgressIndicator()),
              Expanded(
                child: ListView.builder(
                  itemCount: lyricHeaderList.length,
                  itemBuilder: (context, idx) {
                    return ListTile(
                      title: Text(lyricHeaderList[idx].title),
                      onTap: () {
                        // print("$CHORD_URI/${lyricHeaderList[idx].url}");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Apps(
                              url: "$CHORD_URI/${lyricHeaderList[idx].url}",
                              title: lyricHeaderList[idx].title,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}
