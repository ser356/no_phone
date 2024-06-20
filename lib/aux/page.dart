import 'dart:async';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppList extends StatefulWidget {
  const AppList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppListState createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  late Future<List<AppInfo>> _appListFuture;
  List<AppInfo>? _cachedApps;
  DateTime? _lastUpdated;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _appListFuture = getApps(); // Obtiene la lista inicial de apps.
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (_shouldUpdate()) {
        setState(() {
          _appListFuture = getApps();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<List<AppInfo>> getApps() async {
    _cachedApps = await InstalledApps.getInstalledApps(
      true,  // No incluir apps del sistema
      false, // No incluir iconos de apps
      '',    // Sin prefijo de nombre de paquete
    );
    _lastUpdated = DateTime.now();
    return _cachedApps!;
  }

  bool _shouldUpdate() {
    if (_lastUpdated == null) {
      return true;
    }
    return DateTime.now().difference(_lastUpdated!).inMinutes >= 5;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppInfo>>(
      future: _cachedApps != null ? Future.value(_cachedApps) : _appListFuture,
      builder: (BuildContext context, AsyncSnapshot<List<AppInfo>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
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
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.black,
            body: FractionallySizedBox(
              heightFactor: 2/3, // Ajusta este valor para mover el reloj hacia arriba o hacia abajo
              child: Align(
                alignment: Alignment.center,
                child: AnalogClock(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  width: 200.0,
                  isLive: true,
                  hourHandColor: Colors.white,
                  minuteHandColor: Colors.white,
                  showSecondHand: true,
                  numberColor: Colors.white,
                  showNumbers: true,
                  textScaleFactor: 1.5,
                  showTicks: true,
                  showDigitalClock: false,
                  datetime: DateTime.now(),
                ),
              ),
            ),
          ),
          const Scaffold(
            backgroundColor: Colors.black,
            body: AppList(),
          ),
        ],
      ),
    );
  }
}