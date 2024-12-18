import 'dart:convert';
import 'dart:math';

import 'package:chord_indonesia/app_bar.dart';
import 'package:chord_indonesia/daftar_lyric.dart';
import 'package:chord_indonesia/helper.dart';
import 'package:chord_indonesia/model/artist.dart';
import 'package:chord_indonesia/model/catalog.dart';
import 'package:chord_indonesia/model/cookies.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});
  static const String routeName = '/artist-page';

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  bool isLoading = true;
  List<Catalog> catalogs = [];
  List<Artist> listArtist = [];
  List<Artist> findArtists = [];
  List<int> expandedIndex = [];

  late ScrollController scrollController = ScrollController();

  Future<List<Catalog>> loadListOfArtist() async {
    //get lastFetchCatalog
    Cookies? cookies = await loadLocalConfig();
    // print(cookies);
    if (cookies == null) {
      catalogs = await fetchListOfArtist();
      saveJsonListToLocal(catalogs, "catalogs.json");
      //save to config
      saveJsonToLocal(
        {"lastFetchCatalog": DateTime.now().millisecondsSinceEpoch},
        "cookies.json",
      );
    } else {
      catalogs = List<Catalog>.from(
        (await loadJsonListFromLocal("catalogs.json"))
            .map((e) => Catalog.fromMap(e)),
      );
      // print(catalogs);
    }
    //if lastFetchCatalog >= 2 weeks then fetch and save to loacal again
    //else loadCatalogFromLocal

    return catalogs;
  }

  catalogToArtistList(List<Catalog> catalogs) {
    List<Artist> artistList = [];
    for (var i = 0; i < catalogs.length; i++) {
      var catalog = catalogs[i];
      artistList.add(Artist(name: catalog.title, url: ""));
      for (var j = 0; j < catalog.artist.length; j++) {
        var artist = catalog.artist[j];
        artistList.add(Artist(name: artist.name, url: artist.url));
      }
    }
    return artistList;
  }

  searchArtist(String val) {
    setState(() {
      findArtists = listArtist
          .where((element) =>
              element.name.toLowerCase().contains(val.toLowerCase()))
          .toList();
    });
    print(findArtists[0]);
  }

  Future<Cookies?> loadLocalConfig() async {
    try {
      Cookies cookies =
          Cookies.fromMap(await loadJsonFromLocal("cookies.json"));
      return cookies;
    } catch (ex) {
      return null;
    } finally {}
  }

  @override
  void initState() {
    super.initState();
    loadListOfArtist().then((value) {
      setState(() {
        listArtist = catalogToArtistList(catalogs);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: "Daftar Artist"),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Visibility(
                visible: isLoading, child: const LinearProgressIndicator()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.find_in_page),
                  label: Text("Cari Artist"),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  searchArtist(val);
                },
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: listDataArtist(
                      findArtists.isNotEmpty ? findArtists : listArtist,
                      scrollController: scrollController,
                      onTap: (artist) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DaftarLirikPage(
                              artist: artist,
                            ),
                          ),
                        );
                        // print(url);
                      },
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Container(
                      width: 30,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      margin: const EdgeInsets.only(right: 4, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: catalogs
                            .map(
                              (e) => Container(
                                width: 20,
                                margin: const EdgeInsets.only(right: 4),
                                child: InkWell(
                                  onTap: () {
                                    print("${e.title} tap");
                                  },
                                  child: Text(e.title,
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listDataArtist(List<Artist> artistList,
      {ScrollController? scrollController, Function(Artist artist)? onTap}) {
    return ListView.builder(
      controller: scrollController,
      itemCount: artistList.length,
      // shrinkWrap: true,
      itemBuilder: (context, idx) {
        var artist = artistList[idx];
        return ListTile(
          title: Text(artist.name),
          leading: Icon(
            artist.url == "" ? Icons.contact_page : Icons.person_outline,
          ),
          onTap: onTap == null ? null : () => onTap(artistList[idx]),
        );
      },
    );
  }

  late ScrollController _scrollListener;

  Drag? drag;

  DragStartDetails? dragStartDetails;

  bool _onNotification(ScrollNotification notification) {
    var metrics = notification.metrics;
    if (notification is ScrollEndNotification) {
      drag = null;
    }
    if (metrics.axis == Axis.horizontal) {
      return true;
    }
    if (notification is ScrollStartNotification) {
      drag = null;
      dragStartDetails = notification.dragDetails;
    }
    if (notification is UserScrollNotification) {
      if (metrics.pixels <= metrics.minScrollExtent) {
        if (drag == null && dragStartDetails != null) {
          drag = _scrollListener.position.drag(dragStartDetails!, () {
            drag = null;
          });
        }
      } else if (metrics.pixels >= metrics.maxScrollExtent) {
        if (drag == null && dragStartDetails != null) {
          drag = _scrollListener.position.drag(dragStartDetails!, () {
            drag = null;
          });
        }
      }
    }
    return true;
  }
}

class ListSection implements ExpandableListSection<Artist> {
  //store expand state.
  late bool expanded;

  //return item model list.
  late List<Artist> items;

  //example header, optional
  late Catalog header;

  @override
  List<Artist> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}
