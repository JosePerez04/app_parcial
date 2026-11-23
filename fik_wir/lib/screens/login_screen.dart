import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../style/app_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final correo = TextEditingController();
  final clave = TextEditingController();
  bool cargando = false;
  bool ocultar = true;

  @override
  void dispose() {
    correo.dispose();
    clave.dispose();
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
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Correo o contraseña incorrectos.';
      case 'invalid-email':
        return 'El correo no tiene un formato válido.';
      case 'user-disabled':
        return 'Esta cuenta está deshabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos. Inténtalo más tarde.';
      case 'network-request-failed':
        return 'Sin conexión a internet.';
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con ese correo usando otro método.';
      default:
        return 'Error: ${e.message ?? e.code}';
    }
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
    return null;
  }

  Future<void> loginCorreo() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => cargando = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: correo.text.trim(),
        password: clave.text,
      );
    } on FirebaseAuthException catch (e) {
      mensaje(errorFirebase(e));
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  Future<void> loginGoogle() async {
    setState(() => cargando = true);
    try {
      final cuenta = await GoogleSignIn.instance.authenticate();
      final auth = cuenta.authentication;
      final credencial = GoogleAuthProvider.credential(idToken: auth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credencial);
    } on GoogleSignInException catch (e) {
      if (e.code != GoogleSignInExceptionCode.canceled) {
        mensaje('No se pudo iniciar con Google.');
      }
    } on FirebaseAuthException catch (e) {
      mensaje(errorFirebase(e));
    } catch (e) {
      mensaje('No se pudo iniciar con Google.');
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  Future<void> loginFacebook() async {
    setState(() => cargando = true);
    try {
      final resultado = await FacebookAuth.instance.login();
      if (resultado.status == LoginStatus.success) {
        final token = resultado.accessToken!.tokenString;
        final credencial = FacebookAuthProvider.credential(token);
        await FirebaseAuth.instance.signInWithCredential(credencial);
      } else if (resultado.status != LoginStatus.cancelled) {
        mensaje('No se pudo iniciar con Facebook.');
      }
    } on FirebaseAuthException catch (e) {
      mensaje(errorFirebase(e));
    } catch (e) {
      mensaje('No se pudo iniciar con Facebook.');
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

  Widget logo() {
    return Center(
      child: Container(
        width: 92,
        height: 92,
        decoration: AppStyle.logoGrande,
        child: const Icon(Icons.play_arrow_rounded,
            size: 58, color: Colors.white),
      ),
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

  Widget botonPrincipal() {
    return Container(
      decoration: AppStyle.botonPrincipal,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: cargando ? null : loginCorreo,
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
                  : const Text('Iniciar sesión',
                      style: AppStyle.textoBotonPrincipal),
            ),
          ),
        ),
      ),
    );
  }

  Widget separador() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppStyle.lineaSeparador)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('o continúa con', style: AppStyle.textoSeparador),
        ),
        Expanded(child: Divider(color: AppStyle.lineaSeparador)),
      ],
    );
  }

  Widget botonSocial(String texto, IconData icono, VoidCallback? accion) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: accion,
        icon: Icon(icono, size: 22),
        label: Text(texto),
        style: AppStyle.botonSocial,
      ),
    );
  }

  Widget enlaceRegistro() {
    return TextButton(
      onPressed: () => context.go('/registro'),
      child: const Text.rich(
        TextSpan(
          text: '¿No tienes cuenta? ',
          style: AppStyle.enlaceGris,
          children: [
            TextSpan(text: 'Regístrate', style: AppStyle.enlaceResaltado),
          ],
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
            campoCorreo(),
            const SizedBox(height: 16),
            campoClave(),
            const SizedBox(height: 24),
            botonPrincipal(),
            const SizedBox(height: 24),
            separador(),
            const SizedBox(height: 20),
            Row(
              children: [
                botonSocial('Google', Icons.g_mobiledata,
                    cargando ? null : loginGoogle),
                const SizedBox(width: 12),
                botonSocial('Facebook', Icons.facebook,
                    cargando ? null : loginFacebook),
              ],
            ),
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
            Positioned(top: -120, left: -100, child: luz(340, AppColors.rosa)),
            Positioned(
                bottom: -140, right: -120, child: luz(380, AppColors.naranja)),
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
                        logo(),
                        const SizedBox(height: 20),
                        const Text('fikwir',
                            textAlign: TextAlign.center,
                            style: AppStyle.tituloApp),
                        const SizedBox(height: 6),
                        const Text('Videos que te mueven',
                            textAlign: TextAlign.center,
                            style: AppStyle.lema),
                        const SizedBox(height: 32),
                        tarjetaFormulario(),
                        const SizedBox(height: 20),
                        enlaceRegistro(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}