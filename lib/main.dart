import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';
import './screens/loginpage.dart';
import './providers/auth_check.dart';
import './screens/upload.dart';
import './screens/songs_list.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /* theme: new ThemeData(
          hintColor: Colors.white,
          accentColor: Colors.white,
          primaryColor: Colors.white), */
      debugShowCheckedModeBanner: false,
      title: "My Player",
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: AuthCheck(),
          ),
        ],
        child: new MaterialApp(
          title: "MyPlayer",
          home: LoginPage(),
          /* SignupScreen(), */
          theme: ThemeData(fontFamily: 'IBM'),
          routes: {
            //'/playerScreen': (routeCtx) => PlayerScreen(),
            '/upload': (routeCtx) => Upload(),
            '/songs-List': (routeCtx) => SongsList(),
          },
        ),
      ),
    );
  }
}
