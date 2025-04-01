import 'package:bridgecare/features/home/presentation/pages/utils/constans.dart';
import 'package:flutter/material.dart';

import 'package:bridgecare/features/bridge_management/inventory/presentation/pages/inventario_form_page.dart';
import 'package:bridgecare/features/search_bridge/presentation/pages/search_bridge.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 1;

  final List<String> titles = [
    "Bienvenido a BridgeCare",
    "",
  ];

  final List<String> subtitles = [
    "Si tiene alguna duda sobre el funcionamiento de la aplicación, consulte uno de los siguientes manuales: /n Si no tiene dudas presione siguiente ",
    "Usted desea: ",
  ];

  final List<Color> colors = [pageBlue, pageYellow];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final safePadding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              color: colors[page - 1],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(125.0),
                bottomRight: Radius.circular(125.0),
              ),
            ),
          ),
          separator40V,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Text(
                  titles[page - 1],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                separator20V,
                if (page == 1) ...[
                  Text(
                    "Si tiene alguna duda sobre el funcionamiento de la aplicación, consulte uno de los siguientes manuales:",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  separator20V,
                  ElevatedButton.icon(
                    onPressed: () {
                      // Aquí abres o descargas el PDF
                      // Si está en assets: Navigator.push(...) a vista con PDF Viewer
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("Ver manual PDF"),
                  ),
                  separator20V,
                  const Text(
                    "Si no tiene dudas, presione siguiente",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ] else if (page == 2) ...[
                  Text(
                    subtitles[page - 1],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  separator20V,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InventoryFormScreen(usuarioId: 1),
                            ),
                          );
                        },
                        child: const Text("Nuevo"),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BridgeListScreen(),
                            ),
                          );
                        },
                        child: const Text("Buscar"),
                      ),

                    ],
                  ),
                ],
              ],
            ),
          ),

          const Spacer(),
          Padding(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              bottom: safePadding.bottom > 0 ? safePadding.bottom : 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dots
                Row(
                  children: List.generate(
                    3,
                        (index) => Row(
                      children: [
                        _DotsIndicator(
                          size: page == index + 1 ? 10.0 : 5.0,
                          color: page == index + 1
                              ? colors[page - 1]
                              : Colors.grey,
                        ),
                        if (index != 2) separator10H,
                      ],
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 56.0 * 1.3,
                      height: 56.0 * 1.3,
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation(colors[page - 1]),
                        strokeWidth: 2.0,
                        value: (1.0 / 2) * page,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          page = page < 2 ? page + 1 : 1;
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colors[page - 1],
                        minimumSize: const Size(56.0, 56.0),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.chevron_right),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dot widget definido dentro del mismo archivo porque solo se usa aquí
class _DotsIndicator extends StatelessWidget {
  final double size;
  final Color color;
  const _DotsIndicator({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
