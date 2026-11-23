# fik_wir

App en Flutter con autenticación en Firebase y un feed de videos vertical estilo TikTok.

*Autor:* José David Cogollo Pérez
*Institución:* Unitecnar

## Funcionalidades

- Registro con nombre completo, correo y contraseña (mínimo 6 caracteres).
- Inicio de sesión con correo y contraseña.
- Inicio de sesión con Google.
- Inicio de sesión con Facebook.
- Rutas protegidas con go_router: sin sesión solo se accede a /login y /registro; con sesión se accede a /feed.
- Feed de 4 videos verticales a pantalla completa, con reproducción automática solo del video visible, pausa y reanudación al tocar, y botones de me gusta, comentario y compartir.
- Botón de cerrar sesión que muestra nombre y correo, y cierra la sesión de Firebase, Google y Facebook.

## Tecnologías

- Flutter y Dart
- firebase_core y firebase_auth
- google_sign_in
- flutter_facebook_auth
- go_router
- video_player

## Evidencia

### Video de demostración

[Ver video de demostración](evidencias/video-prueba.mp4)

Muestra el registro, el inicio de sesión con correo, Google y Facebook, y el feed.

### Registro con correo

| Formulario de registro | Credenciales ingresadas | Usuario en la app |
|---|---|---|
| 

![Registro](evidencias/registro.jpg)

 | 

![Credenciales](evidencias/credenciales%20del%20registro.jpg)

 | 

![Usuario](evidencias/usuario%20del%20registro.jpg)

 |

### Inicio de sesión



![Login](evidencias/login.jpg)



### Inicio de sesión con Google

| Acceso con Google | Usuario en la app |
|---|---|
| 

![Google](evidencias/registro%20google.jpg)

 | 

![Usuario Google](evidencias/usuario%20de%20google.jpg)

 |

### Inicio de sesión con Facebook

| Acceso con Facebook | Usuario en la app |
|---|---|
| 

![Facebook](evidencias/registro%20facebook.jpg)

 | 

![Usuario Facebook](evidencias/usuario%20de%20facebook.jpg)

 |

