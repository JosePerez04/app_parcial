import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_player/video_player.dart';

import '../style/app_style.dart';


class VideoData {
  final String ruta;
  final String usuario;
  final String descripcion;
  final int likes;
  final int comentarios;
  final int compartidos;
  const VideoData(this.ruta, this.usuario, this.descripcion, this.likes,
      this.comentarios, this.compartidos);
}

const List<VideoData> videos = [
  VideoData('assets/videos/video1.mp4', '@usuario1',
      'Mi primer video #fikwir #viral', 12400, 342, 89),
  VideoData('assets/videos/video2.mp4', '@usuario2',
      'Disfrutando el día #vibes', 8650, 120, 45),
  VideoData('assets/videos/video3.mp4', '@usuario3',
      'Algo para compartir #fyp', 20300, 580, 210),
  VideoData('assets/videos/video4.mp4', '@usuario4',
      'Último video del feed #fikwir', 5100, 76, 30),
];

String formato(int n) {
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
  return '$n';
}


class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> {
  final pageController = PageController();
  final focusNode = FocusNode();
  int actual = 0;

  @override
  void dispose() {
    pageController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  
  Future<void> logout() async {
    
    await FirebaseAuth.instance.signOut();
    
    try {
      await GoogleSignIn.instance
          .signOut()
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      
    }
    try {
      await FacebookAuth.instance
          .logOut()
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      
    }
  }

  void irA(int pagina) {
    if (pagina < 0 || pagina >= videos.length) return;
    pageController.animateToPage(
      pagina,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  KeyEventResult teclado(FocusNode nodo, KeyEvent evento) {
    if (evento is KeyDownEvent) {
      if (evento.logicalKey == LogicalKeyboardKey.arrowDown) {
        irA(actual + 1);
        return KeyEventResult.handled;
      }
      if (evento.logicalKey == LogicalKeyboardKey.arrowUp) {
        irA(actual - 1);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  
  Widget logoYContador() {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: AppStyle.logoMini,
          child: const Icon(Icons.play_arrow_rounded,
              color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: AppStyle.chipContador,
          child: Text('${actual + 1}/${videos.length}',
              style: AppStyle.textoContador),
        ),
      ],
    );
  }

  Widget chipUsuario() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snap) {
        final u = snap.data;
        final texto = (u?.displayName?.isNotEmpty ?? false)
            ? u!.displayName!
            : (u?.email ?? 'Usuario');
        final inicial = texto.isNotEmpty ? texto[0].toUpperCase() : '?';
        return Material(
          color: Colors.black45,
          shape: const StadiumBorder(),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: logout,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 12, 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.naranja,
                    child: Text(inicial, style: AppStyle.inicialAvatar),
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 110),
                    child: Text(texto,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.nombreChip),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.logout, color: Colors.white70, size: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget barraSuperior() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [logoYContador(), chipUsuario()],
        ),
      ),
    );
  }

  Widget listaVideos() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        onPageChanged: (i) => setState(() => actual = i),
        itemBuilder: (context, i) =>
            VideoItem(data: videos[i], activo: i == actual),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        focusNode: focusNode,
        autofocus: true,
        onKeyEvent: teclado,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Stack(
              children: [
                listaVideos(),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 130,
                  child: IgnorePointer(
                    child: DecoratedBox(decoration: AppStyle.scrimSuperior),
                  ),
                ),
                Positioned(top: 0, left: 0, right: 0, child: barraSuperior()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class VideoItem extends StatefulWidget {
  final VideoData data;
  final bool activo;
  const VideoItem({super.key, required this.data, required this.activo});
  @override
  State<VideoItem> createState() => VideoItemState();
}

class VideoItemState extends State<VideoItem> {
  late final VideoPlayerController controller;
  bool listo = false;
  bool pausadoManual = false;
  bool meGusta = false;
  bool mostrarCorazon = false;
  String? errorVideo;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset(widget.data.ruta);
    controller.setLooping(true);
    controller.initialize().then((valor) {
      if (!mounted) return;
      setState(() => listo = true);
      if (widget.activo) controller.play();
    }).catchError((error) {
      if (!mounted) return;
      setState(() => errorVideo = error.toString());
    });
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listo) return;
    if (widget.activo && !oldWidget.activo) {
      pausadoManual = false;
      controller.seekTo(Duration.zero);
      controller.play();
    } else if (!widget.activo && oldWidget.activo) {
      controller.pause();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void alternar() {
    if (!listo) return;
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
        pausadoManual = true;
      } else {
        controller.play();
        pausadoManual = false;
      }
    });
  }

  void darMeGusta() {
    setState(() {
      meGusta = true;
      mostrarCorazon = true;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => mostrarCorazon = false);
    });
  }

  void snack(String t) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
          SnackBar(content: Text(t), duration: const Duration(seconds: 1)));
  }

  
  Widget capaVideo() {
    if (listo) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      );
    }
    if (errorVideo != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(errorVideo!, style: const TextStyle(color: Colors.white)),
        ),
      );
    }
    return const Center(
        child: CircularProgressIndicator(color: AppColors.naranja));
  }

  Widget iconoPausa() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: AppStyle.circuloPausa,
        child: const Icon(Icons.play_arrow_rounded,
            size: 64, color: Colors.white),
      ),
    );
  }

  Widget corazonGrande() {
    return Center(
      child: AnimatedScale(
        scale: mostrarCorazon ? 1.0 : 0.3,
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        child: AnimatedOpacity(
          opacity: mostrarCorazon ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          child: const Icon(Icons.favorite, color: AppColors.rosa, size: 110),
        ),
      ),
    );
  }

  Widget informacion() {
    return Positioned(
      left: 16,
      right: 92,
      bottom: 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.data.usuario, style: AppStyle.usuarioVideo),
          const SizedBox(height: 8),
          Text(widget.data.descripcion,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.descripcionVideo),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.music_note, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text('Sonido original · ${widget.data.usuario}',
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.sonidoVideo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget avatarCreador() {
    final nombre = widget.data.usuario;
    return SizedBox(
      width: 54,
      height: 62,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: AppStyle.avatarVideo,
            child: Center(
              child: Text(
                nombre.length > 1 ? nombre[1].toUpperCase() : '?',
                style: AppStyle.inicialVideo,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: AppStyle.insigniaMas,
              child: const Icon(Icons.add, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget accion(IconData icono, String texto, VoidCallback onTap,
      {Color color = Colors.white}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: AppStyle.fondoBotonAccion,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(icono, color: color, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(texto, style: AppStyle.textoAccion),
      ],
    );
  }

  Widget botonesLaterales() {
    final likes = widget.data.likes + (meGusta ? 1 : 0);
    return Positioned(
      right: 12,
      bottom: 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          avatarCreador(),
          const SizedBox(height: 14),
          accion(
            meGusta ? Icons.favorite : Icons.favorite_border,
            formato(likes),
            () => setState(() => meGusta = !meGusta),
            color: meGusta ? AppColors.rosa : Colors.white,
          ),
          const SizedBox(height: 14),
          accion(Icons.chat_bubble_outline, formato(widget.data.comentarios),
              () => snack('Comentarios')),
          const SizedBox(height: 14),
          accion(Icons.reply_rounded, formato(widget.data.compartidos),
              () => snack('Compartir')),
        ],
      ),
    );
  }

  Widget barraProgreso() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 3,
      child: VideoProgressIndicator(
        controller,
        allowScrubbing: false,
        padding: EdgeInsets.zero,
        colors: const VideoProgressColors(
          playedColor: AppColors.naranja,
          bufferedColor: Colors.white24,
          backgroundColor: Colors.white12,
        ),
      ),
    );
  }

 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alternar,
      onDoubleTap: darMeGusta,
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            capaVideo(),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 260,
              child: IgnorePointer(
                child: DecoratedBox(decoration: AppStyle.scrimInferior),
              ),
            ),
            if (pausadoManual) iconoPausa(),
            corazonGrande(),
            informacion(),
            botonesLaterales(),
            if (listo) barraProgreso(),
          ],
        ),
      ),
    );
  }
}