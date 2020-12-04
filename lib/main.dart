import 'package:flutter/material.dart';
import 'package:flutter_app/models/home_menu.dart';
import 'package:flutter_app/ui/baato_reverse.dart';
import 'package:flutter_app/ui/baato_search.dart';
import 'package:flutter_app/ui/breeze_map.dart';
import 'package:flutter_app/ui/monochrome_map.dart';
import 'package:flutter_app/ui/retro_map.dart';
import 'baato_routing.dart';

void main() {
  runApp(ListViewApp());
}

class ListViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic List',
      debugShowCheckedModeBanner: false,
      home: ListScreen(),
    );
  }
}

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<HomeMenu> HomeMenus = new List();

  _addHomeMenus() {
    setState(() {
      HomeMenus.add(new HomeMenu(title: "My HomeMenu name", icon: 1));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // for (var i = 0; i < 15; i++) {
    HomeMenus.add(new HomeMenu(title: "Search", icon: 1));
    HomeMenus.add(new HomeMenu(title: "Reverse", icon: 1));
    HomeMenus.add(new HomeMenu(title: "Routing", icon: 1));
    HomeMenus.add(new HomeMenu(title: "Breeze Map", icon: 1));
    HomeMenus.add(new HomeMenu(title: "Monochrome Map", icon: 1));
    HomeMenus.add(new HomeMenu(title: "Retro Map", icon: 1));
    // }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Baato Flutter"),
      ),
      body: new StringList(HomeMenus: HomeMenus),
    );
  }
}

class StringList extends StatelessWidget {
  final List<HomeMenu> HomeMenus;

  StringList({@required this.HomeMenus});

  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.separated(
      itemCount: HomeMenus.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.deepOrange,
      ),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${HomeMenus[index].title}'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BaatoSearchExample()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BaatoReverseExample()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BaatoDirectionsExample()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BreezeMapStyle()),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MonochromeMapStyle()),
                );
                break;
              case 5:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RetroMapStyle()),
                );
                break;
            }
            print('tapped' + HomeMenus[index].title);
          },
        );
      },
    );
  }
}

// replace this function with the code in the examples
Widget _myListView(BuildContext context) {
  return ListView(
    children: <Widget>[
      ListTile(
        // leading: Icon(Icons.search),
        title: Text('Search'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
      ListTile(
        // leading: Icon(Icons.maps_ugc_outlined),
        title: Text('Reverse'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
      ListTile(
        // leading: Icon(Icons.navigation),
        title: Text('Routing'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
      ListTile(
        // leading: Icon(Icons.map_outlined),
        title: Text('Breeze Map'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
      ListTile(
        // leading: Icon(Icons.maps_ugc_outlined),
        title: Text('Retro Map'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
      ListTile(
        // leading: Icon(Icons.star),
        title: Text('Monochrome Map'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Grid List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(6, (index) {
            return Center(
              child: Text(
                'HomeMenu $index',
                style: Theme.of(context).textTheme.headline5,
              ),
            );
          }),
        ),
      ),
    );
  }
}
