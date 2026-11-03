
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Inicia la aplicación y el servicio de anuncios.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Google AdMob.
  MobileAds.instance.initialize();

  runApp(const MiAplicacion());
}

// Configuración principal de la aplicación.
class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaInicio(),
    );
  }
}

// Pantalla donde aparecerá el anuncio.
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  BannerAd? _banner;

  @override
  void initState() {
    super.initState();
    cargarBanner();
  }

  // Solicita el anuncio a Google AdMob.
  void cargarBanner() {
    final anuncio = BannerAd(
      // Identificador del anuncio de prueba número 4.
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',

      // Banner fijo de 320 x 50 dp.
      size: AdSize.banner,

      request: const AdRequest(),

      listener: BannerAdListener(
        // Se ejecuta cuando el anuncio se carga.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {
            _banner = ad as BannerAd;
          });

          debugPrint('Banner cargado correctamente');
        },

        // Se ejecuta si ocurre un error.
        onAdFailedToLoad: (ad, error) {
          debugPrint('Error al cargar banner: $error');
          ad.dispose();
        },
      ),
    );

    // Inicia la carga del anuncio.
    anuncio.load();
  }

  @override
  void dispose() {
    // Libera los recursos del anuncio.
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner de tamaño fijo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, size: 80),
            SizedBox(height: 20),
            Text(
              'Integración de Google AdMob',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text('Anuncio de demostración número 4'),
          ],
        ),
      ),

      // Coloca el anuncio en la parte inferior.
      bottomNavigationBar: _banner == null
          ? null
          : SafeArea(
              top: false,
              child: SizedBox(
                height: _banner!.size.height.toDouble(),
                child: Center(
                  child: SizedBox(
                    width: _banner!.size.width.toDouble(),
                    height: _banner!.size.height.toDouble(),
                    child: AdWidget(ad: _banner!),
                  ),
                ),
              ),
            ),
    );
  }
}
