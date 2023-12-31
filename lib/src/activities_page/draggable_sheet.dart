import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'searchbar.dart';
import '../activities_list.dart';
import '../example_activities.dart';

class DraggableSheet extends StatefulWidget {
  final VoidCallback setActState;
  const DraggableSheet({Key? key, required this.setActState});

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  final DraggableScrollableController _scrollableController =
      DraggableScrollableController();

  final double openSize = 0.8;
  final double closeSize = 0.14;

  List<int> filteredIndices = [];

  @override
  void initState() {
    super.initState();

    // populate filtered list at init state
    for (int i = 0; i < exampleActivities.length; i++) {
      if (!usersActivities.contains(i)) {
        filteredIndices.add(i);
      }
    }
  }

  void _openSheet() {
    _scrollableController.animateTo(
      openSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void filter(String searchText) {
    if (searchText != "?") {
      filteredIndices = List.generate(exampleActivities.length, (index) => index)
          .where((index) => exampleActivities[index].title
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }

    filteredIndices.removeWhere((index) => usersActivities.contains(index));

    print(filteredIndices);
    setState(() {});
  }

  // store user's activities in shared prefs
  Future<void> storeUserActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final stringList =
        usersActivities.map((activity) => activity.toString()).toList();
    await prefs.setStringList('usersActivitiesSP', stringList);
    widget.setActState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      controller: _scrollableController, // Pass the controller
      initialChildSize: closeSize,
      minChildSize: closeSize,
      maxChildSize: openSize,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    spreadRadius: 10,
                    blurRadius: 30,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  SliverPersistentHeader(
                    delegate: CustomHeaderDelegate(openSheet: () {
                      _openSheet();
                    }, filter: (searchText) {
                      filter(searchText);
                    }),
                    pinned: true,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index < filteredIndices.length) {
                          final emoji = exampleActivities[filteredIndices[index]].icon;
                          final activity =
                              exampleActivities[filteredIndices[index]].title;
                          return ListTile(
                            leading:
                                Text(emoji, style: TextStyle(fontSize: 24)),
                            title: Text(activity),
                            trailing: IconButton(
                              icon: Icon(Icons
                                  .add_outlined), // prolly should change this
                              onPressed: () {
                                if (!usersActivities
                                    .contains(filteredIndices[index])) {
                                  // add index to users activities
                                  usersActivities.add(filteredIndices[index]);
                                  storeUserActivities();
                                  filter("?");

                                  print("Added $index to usersActivities");
                                  print(
                                      "current userActivities: $usersActivities");
                                } else {
                                  // benign
                                  usersActivities
                                      .remove(filteredIndices[index]);
                                  storeUserActivities();
                                  print("Removed $index from usersActivies");
                                  print(
                                      "current userActivities: $usersActivities");
                                }
                              },
                            ),
                          );
                        } else {
                          return null;
                        }
                      },
                      childCount: exampleActivities.length,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
