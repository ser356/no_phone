import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<List<Application>>(
          future: DeviceApps.getInstalledApplications(
            includeSystemApps: true,
            onlyAppsWithLaunchIntent: true,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  Application app = snapshot.data![index];
                  return ListTile(
                    title: Text(
                      app.appName,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => DeviceApps.openApp(app.packageName),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}