import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/screens/auth_screen.dart';
import 'package:firebase_app/screens/intro_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/chat.dart';

bool isFirst;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget screen = MyApp();

  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  isFirst = pref.getBool('first');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isFirst == null || !isFirst
          ? IntroScreen()
          : StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ChatingScreen();
                } else {
                  return AuthScreen();
                }
              },
            ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: null,
    );
  }
}

// import 'package:firebase_app/auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<Auth>(
//           create: (_) => Auth(),
//         ),
//         ChangeNotifierProxyProvider<Auth, Products>(
//             create: (_) => Products(),
//             update: (ctc, value, oldProducts) => oldProducts
//               ..getData(value.token,
//                   oldProducts == null ? [] : oldProducts.productsList)),
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Auth>(
//       builder: (context, value, _) => MaterialApp(
//         theme: ThemeData(
//             primaryColor: Colors.orange,
//             canvasColor: Color.fromRGBO(255, 238, 219, 1)),
//         debugShowCheckedModeBanner: false,
//         home: value.isAuth
//             ? MyHomePage()
//             : FutureBuilder(
//                 future: value.tryAutoLogin(),
//                 builder: (ctx, AsyncSnapshot snapshot) =>
//                     snapshot.connectionState == ConnectionState.waiting
//                         ? SplashScreen()
//                         : AuthScreen(),
//               ),
//       ),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     Provider.of<Products>(context, listen: false)
//         .fetchData()
//         .then((_) => _isLoading = false)
//         .catchError((onError) => print(onError));
//
//     super.initState();
//   }
//
//   Widget detailCard(id, tile, desc, price, imageUrl) {
//     return Builder(
//       builder: (innerContext) => FlatButton(
//         onPressed: () {
//           print(id);
//           Navigator.push(
//             innerContext,
//             MaterialPageRoute(builder: (_) => ProductDetails(id)),
//           ).then(
//               (id) => Provider.of<Products>(context, listen: false).delete(id));
//         },
//         child: Column(
//           children: [
//             SizedBox(height: 5),
//             Card(
//               elevation: 10,
//               color: Color.fromRGBO(115, 138, 119, 1),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     flex: 3,
//                     child: Container(
//                       padding: EdgeInsets.only(right: 10),
//                       width: 130,
//                       child: Hero(
//                         tag: id,
//                         // child: Image.network(imageUrl, fit: BoxFit.fill),
//                         child: FlutterLogo(),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 3,
//                     child: Column(
//                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         SizedBox(height: 10),
//                         Text(
//                           tile,
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Divider(color: Colors.white),
//                         Container(
//                           width: 200,
//                           child: Text(
//                             desc,
//                             style: TextStyle(color: Colors.white, fontSize: 14),
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                             textAlign: TextAlign.justify,
//                             maxLines: 3,
//                           ),
//                         ),
//                         Divider(color: Colors.white),
//                         Text(
//                           "\$$price",
//                           style: TextStyle(color: Colors.black, fontSize: 18),
//                         ),
//                         SizedBox(height: 13),
//                       ],
//                     ),
//                   ),
//                   Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Product> prodList =
//         Provider.of<Products>(context, listen: true).productsList;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Products'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             onPressed: () => Provider.of<Auth>(context, listen: false).logout(),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//               child: SpinKitFadingFour(
//                 color: Colors.red,
//                 size: 50.0,
//               ),
//             )
//           : (prodList.isEmpty
//               ? Center(
//                   child: Text('No Products Added.',
//                       style: TextStyle(fontSize: 22)))
//               : RefreshIndicator(
//                   onRefresh: () async =>
//                       await Provider.of<Products>(context, listen: false)
//                           .fetchData(),
//                   child: ListView(
//                     children: prodList
//                         .map(
//                           (item) => detailCard(item.id, item.title,
//                               item.description, item.price, item.imageUrl),
//                         )
//                         .toList(),
//                   ),
//                 )),
//       floatingActionButton: Container(
//         width: 180,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.0),
//           color: Theme.of(context).primaryColor,
//         ),
//         child: FlatButton.icon(
//           label: Text("Add Product",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
//           icon: Icon(Icons.add),
//           onPressed: () => Navigator.push(
//               context, MaterialPageRoute(builder: (_) => AddProduct())),
//         ),
//       ),
//     );
//   }
// }
//
// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: SpinKitFadingFour(
//             color: Colors.red,
//             size: 100.0,
//           ),
//         ),
//       ),
//     );
//   }
// }
