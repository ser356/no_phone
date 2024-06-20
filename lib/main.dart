import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

void main() {
  runApp(const MyApp(key: Key('myAppKey')));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  Future<List<AppInfo>> getApps() async {
    return await InstalledApps.getInstalledApps(
      true,
      false,
      ''
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          const Scaffold(
            backgroundColor: Colors.black, // Primer contenedor para otros contenidos
            body: Center(child: Text('Desliza hacia la derecha para ver las apps', style: TextStyle(color: Colors.white))),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: FutureBuilder<List<AppInfo>>(
              future: getApps(
                
              ),
              builder: (BuildContext context, AsyncSnapshot<List<AppInfo>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => InstalledApps.startApp(snapshot.data![index].packageName),
                        child: ListTile(
                          title: Text(snapshot.data![index].name, style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
