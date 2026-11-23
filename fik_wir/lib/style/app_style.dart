import 'package:flutter/material.dart';

class AppColors {
  static const Color naranja = Color(0xFFFF6A3D);
  static const Color rosa = Color(0xFFFF2E7E);
  static const Color errorClaro = Color(0xFFFFB4A8);
  static const Color fondoA = Color(0xFF12061F);
  static const Color fondoB = Color(0xFF2B0F4A);
  static const Color fondoC = Color(0xFF5A1A52);
}

class AppStyle {
  
  static const LinearGradient marca = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.naranja, AppColors.rosa],
  );

  static const LinearGradient fondo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.fondoA, AppColors.fondoB, AppColors.fondoC],
  );

  
  static const BoxDecoration fondoPantalla = BoxDecoration(gradient: fondo);

  static BoxDecoration luz(Color color) {
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [color.withValues(alpha: 0.45), color.withValues(alpha: 0)],
      ),
    );
  }

  static final BoxDecoration logoGrande = BoxDecoration(
    shape: BoxShape.circle,
    gradient: marca,
    boxShadow: [
      BoxShadow(
        color: AppColors.rosa.withValues(alpha: 0.55),
        blurRadius: 36,
        spreadRadius: 2,
      ),
    ],
  );

  static const BoxDecoration logoMini = BoxDecoration(
    shape: BoxShape.circle,
    gradient: marca,
  );

  
  static const TextStyle tituloApp = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: 2,
    color: Colors.white,
  );

  static const TextStyle lema = TextStyle(
    fontSize: 15,
    color: Colors.white70,
    letterSpacing: 0.6,
  );

  static final BoxDecoration tarjeta = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.07),
    borderRadius: BorderRadius.circular(28),
    border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
  );

  static const TextStyle textoCampo = TextStyle(color: Colors.white);

  static OutlineInputBorder borde(Color color, [double ancho = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: ancho),
    );
  }

  static InputDecoration campo(String etiqueta, IconData icono,
      {Widget? sufijo}) {
    return InputDecoration(
      labelText: etiqueta,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icono, color: Colors.white70),
      suffixIcon: sufijo,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.08),
      errorStyle: const TextStyle(color: AppColors.errorClaro),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: borde(Colors.transparent),
      enabledBorder: borde(Colors.white.withValues(alpha: 0.12)),
      focusedBorder: borde(AppColors.naranja, 1.8),
      errorBorder: borde(AppColors.errorClaro),
      focusedErrorBorder: borde(AppColors.errorClaro, 1.8),
    );
  }

  static final BoxDecoration botonPrincipal = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    gradient: const LinearGradient(
        colors: [AppColors.naranja, AppColors.rosa]),
    boxShadow: [
      BoxShadow(
        color: AppColors.rosa.withValues(alpha: 0.4),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static const TextStyle textoBotonPrincipal = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static const TextStyle textoSeparador =
      TextStyle(color: Colors.white54, fontSize: 13);

  static final Color lineaSeparador = Colors.white.withValues(alpha: 0.2);

  static final ButtonStyle botonSocial = OutlinedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.white.withValues(alpha: 0.06),
    side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static const TextStyle enlaceGris = TextStyle(color: Colors.white70);

  static const TextStyle enlaceResaltado = TextStyle(
    color: AppColors.naranja,
    fontWeight: FontWeight.w700,
  );

  
  static const BoxDecoration scrimSuperior = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.black54, Colors.transparent],
    ),
  );

  static const BoxDecoration scrimInferior = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [Colors.black87, Colors.transparent],
    ),
  );

  static const BoxDecoration chipContador = BoxDecoration(
    color: Colors.black38,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  static const TextStyle textoContador = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle inicialAvatar =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  static const TextStyle nombreChip =
      TextStyle(color: Colors.white, fontSize: 13);

  static const TextStyle usuarioVideo = TextStyle(
    color: Colors.white,
    fontSize: 19,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle descripcionVideo =
      TextStyle(color: Colors.white, fontSize: 14, height: 1.3);

  static const TextStyle sonidoVideo =
      TextStyle(color: Colors.white70, fontSize: 13);

  static const TextStyle textoAccion = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle inicialVideo = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const BoxDecoration avatarVideo = BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(colors: [AppColors.naranja, AppColors.rosa]),
    border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
  );

  static const BoxDecoration insigniaMas = BoxDecoration(
    color: AppColors.rosa,
    shape: BoxShape.circle,
  );

  static const BoxDecoration circuloPausa = BoxDecoration(
    color: Colors.black45,
    shape: BoxShape.circle,
  );

  static final Color fondoBotonAccion = Colors.white.withValues(alpha: 0.14);
}