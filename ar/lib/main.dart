import 'package:ar/mapScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MapScreen()));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late ArCoreController arCoreController;
//
//   Future<void> checkARSupport() async {
//     bool isArCoreAvailable = await ArCoreController.checkArCoreAvailability();
//     bool isArCoreInstalled = await ArCoreController.checkIsArCoreInstalled();
//
//     if (isArCoreAvailable && isArCoreInstalled) {
//       print("ARCore is supported and installed on this device.");
//       // Proceed to launch AR feature
//     } else if (!isArCoreAvailable) {
//       print("ARCore is not available on this device.");
//     } else {
//       print("ARCore is available but not installed.");
//       // You may want to prompt the user to install/update Google Play Services for AR
//     }
//   }
//
//   void _onArCoreViewCreated(ArCoreController controller) {
//     arCoreController = controller;
//
//     _addSphere(arCoreController);
//     _addCylinder(arCoreController);
//     _addCube(arCoreController);
//   }
//
//   void _addSphere(ArCoreController controller) {
//     final material = ArCoreMaterial(
//         color: Color.fromARGB(120, 66, 134, 244));
//     final sphere = ArCoreSphere(
//       materials: [material],
//       radius: 0.1,
//     );
//     final node = ArCoreNode(
//       shape: sphere,
//       position: vector.Vector3(0, 0, -1.5),
//     );
//     controller.addArCoreNode(node);
//   }
//
//   void _addCylinder(ArCoreController controller) {
//     final material = ArCoreMaterial(
//       color: Colors.red,
//       reflectance: 1.0,
//     );
//     final cylinder = ArCoreCylinder(
//       materials: [material],
//       radius: 0.5,
//       height: 0.3,
//     );
//     final node = ArCoreNode(
//       shape: cylinder,
//       position: vector.Vector3(0.0, -0.5, -2.0),
//     );
//     controller.addArCoreNode(node);
//   }
//
//   void _addCube(ArCoreController controller) {
//     final material = ArCoreMaterial(
//       color: Color.fromARGB(120, 66, 134, 244),
//       metallic: 1.0,
//     );
//     final cube = ArCoreCube(
//       materials: [material],
//       size: vector.Vector3(0.5, 0.5, 0.5),
//     );
//     final node = ArCoreNode(
//       shape: cube,
//       position: vector.Vector3(-0.5, 0.5, -3.5),
//     );
//     controller.addArCoreNode(node);
//   }
//
//   @override
//   void initState() {
//     checkARSupport();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     arCoreController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('AR'),),
//       body: ArCoreView(onArCoreViewCreated: _onArCoreViewCreated),
//     );
//   }
// }
