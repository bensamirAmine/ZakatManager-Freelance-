// import 'dart:convert';

// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages

// //
// class MapWebViewPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Carte WebView OpenStreetMap')),
//       body: WebView(
//         initialUrl: Uri.dataFromString(
//           '''
//           <!DOCTYPE html>
//           <html>
//           <head>
//             <meta charset="utf-8" />
//             <meta name="viewport" content="width=device-width, initial-scale=1.0">
//             <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
//             <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
//             <style>
//               #map { height: 100vh; }
//             </style>
//           </head>
//           <body>
//             <div id="map"></div>
//             <script>
//               var map = L.map('map').setView([36.8119957755358, 10.138122339036986], 13);
//               L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
//                 maxZoom: 19,
//               }).addTo(map);
//               L.marker([36.8119957755358, 10.138122339036986]).addTo(map)
//                 .bindPopup('Position 1')
//                 .openPopup();
//               L.marker([36.8029967755358, 10.178322339036986]).addTo(map)
//                 .bindPopup('Position 2');
//             </script>
//           </body>
//           </html>
//           ''',
//           mimeType: 'text/html',
//           encoding: Encoding.getByName('utf-8'),
//         ).toString(),
//         // javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }
