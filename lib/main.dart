import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver API Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Driver API Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String base_url = 'https://api.godokdriver.com';
  String responseData = '';

  void _login() async {
    try {
      FormData formData = FormData.fromMap({
        'auth': {
          'email': 'test@test.com',
          'password': 'test1234',
        }
      });

      var response = await getDio().post(
        "/api/v1/auth/login",
        data: formData,
        // {
        //   "auth": {"email": "test@test.com", "password": "test1234"}
        // },
      );
      setState(() {
        responseData = response.data.toString();
      });
    } catch (e) {
      print('에러메세지 : $e');
      setState(() {
        responseData = e.toString();
      });
    }
  }

  Dio getDio({
    String token,
  }) {
    // Map<String, dynamic> headers = Map();
    // if (!isNullOrBlank(token)) {
    // headers['Authorization'] = 'Bearer $token';
    // headers['Content-Type'] = 'application/json';
    // headers['Content-Type'] = 'multipart/form-data';
    // }

    BaseOptions options = BaseOptions(
        baseUrl: base_url,
        // headers: {'Authorization': 'Bearer $token'},
        contentType: Headers.jsonContentType);

    Dio dio = Dio(options);
    dio.interceptors.add(LogInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true));
    return dio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              responseData,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _login,
        tooltip: 'Login Test Button',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
