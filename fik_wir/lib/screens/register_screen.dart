import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../style/app_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final correo = TextEditingController();
  final clave = TextEditingController();
  final confirmar = TextEditingController();
  bool cargando = false;
  bool ocultar = true;

  @override
  void dispose() {
    nombre.dispose();
    correo.dispose();
    clave.dispose();
    confirmar.dispose();
    super.dispose();
  }

  
  void mensaje(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  String errorFirebase(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Ese correo ya está registrado.';
      case 'weak-password':
        return 'La contraseña es muy débil.';
      case 'invalid-email':
        return 'El correo no tiene un formato válido.';
      case 'operation-not-allowed':
        return 'El registro con correo no está habilitado.';
      case 'network-request-failed':
        return 'Sin conexión a internet.';
      default:
        return 'Error: ${e.message ?? e.code}';
    }
  }

  String? validarNombre(String? v) {
    if (v == null || v.trim().isEmpty) return 'El nombre es obligatorio';
    return null;
  }

  String? validarCorreo(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'El correo es obligatorio';
    final ok = RegExp(r'^[\w\.\-+]+@[\w\-]+\.[\w\.\-]+$').hasMatch(t);
    if (!ok) return 'Formato de correo no válido';
    return null;
  }

  String? validarClave(String? v) {
    if (v == null || v.isEmpty) return 'La contraseña es obligatoria';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? validarConfirmar(String? v) {
    if (v == null || v.isEmpty) return 'Confirma tu contraseña';
    if (v != clave.text) return 'Las contraseñas no coinciden';
    return null;
  }

  Future<void> registrar() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => cargando = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo.text.trim(),
        password: clave.text,
      );
      await cred.user?.updateDisplayName(nombre.text.trim());
      await cred.user?.reload();
      
    } on FirebaseAuthException catch (e) {
      mensaje(errorFirebase(e));
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  
  Widget luz(double tamano, Color color) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: AppStyle.luz(color),
    );
  }

  Widget botonVolver() {
    return Positioned(
      top: 0,
      left: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () => context.go('/login'),
          ),
        ),
      ),
    );
  }

  Widget encabezado() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: AppStyle.logoGrande,
          child: const Icon(Icons.person_add_alt_1_rounded,
              size: 36, color: Colors.white),
        ),
        const SizedBox(height: 18),
        Text('Crear cuenta',
            textAlign: TextAlign.center,
            style: AppStyle.tituloApp.copyWith(fontSize: 30)),
        const SizedBox(height: 6),
        const Text('Únete y empieza a ver videos',
            textAlign: TextAlign.center, style: AppStyle.lema),
      ],
    );
  }

  Widget campoNombre() {
    return TextFormField(
      controller: nombre,
      textCapitalization: TextCapitalization.words,
      style: AppStyle.textoCampo,
      cursorColor: AppColors.naranja,
      decoration: AppStyle.campo('Nombre completo', Icons.person_outline),
      validator: validarNombre,
    );
  }

  Widget campoCorreo() {
    return TextFormField(
      controller: correo,
      keyboardType: TextInputType.emailAddress,
      style: AppStyle.textoCampo,
      cursorColor: AppColors.naranja,
      decoration: AppStyle.campo('Correo', Icons.alternate_email),
      validator: validarCorreo,
    );
  }

  Widget campoClave() {
    return TextFormField(
      controller: clave,
      obscureText: ocultar,
      style: AppStyle.textoCampo,
      cursorColor: AppColors.naranja,
      decoration: AppStyle.campo(
        'Contraseña',
        Icons.lock_outline,
        sufijo: IconButton(
          icon: Icon(
            ocultar
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.white70,
          ),
          onPressed: () => setState(() => ocultar = !ocultar),
        ),
      ),
      validator: validarClave,
    );
  }

  Widget campoConfirmar() {
    return TextFormField(
      controller: confirmar,
      obscureText: ocultar,
      style: AppStyle.textoCampo,
      cursorColor: AppColors.naranja,
      decoration:
          AppStyle.campo('Confirmar contraseña', Icons.lock_reset_outlined),
      validator: validarConfirmar,
    );
  }

  Widget botonPrincipal() {
    return Container(
      decoration: AppStyle.botonPrincipal,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: cargando ? null : registrar,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17),
            child: Center(
              child: cargando
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Text('Registrarme',
                      style: AppStyle.textoBotonPrincipal),
            ),
          ),
        ),
      ),
    );
  }

  Widget tarjetaFormulario() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppStyle.tarjeta,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            campoNombre(),
            const SizedBox(height: 16),
            campoCorreo(),
            const SizedBox(height: 16),
            campoClave(),
            const SizedBox(height: 16),
            campoConfirmar(),
            const SizedBox(height: 24),
            botonPrincipal(),
          ],
        ),
      ),
    );
  }

  Widget enlaceLogin() {
    return TextButton(
      onPressed: () => context.go('/login'),
      child: const Text.rich(
        TextSpan(
          text: '¿Ya tienes cuenta? ',
          style: AppStyle.enlaceGris,
          children: [
            TextSpan(text: 'Inicia sesión', style: AppStyle.enlaceResaltado),
          ],
        ),
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyle.fondoPantalla,
        child: Stack(
          children: [
            Positioned(top: -120, right: -100, child: luz(340, AppColors.rosa)),
            Positioned(
                bottom: -140, left: -120, child: luz(380, AppColors.naranja)),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        encabezado(),
                        const SizedBox(height: 28),
                        tarjetaFormulario(),
                        const SizedBox(height: 20),
                        enlaceLogin(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            botonVolver(),
          ],
        ),
      ),
    );
  }
}