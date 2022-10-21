import 'package:retos_proyecto/MenuNavigatioBar/AdminPerfilUser.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/EmailPassw/RecoverPassw.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/splashScreen.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'MenuNavigatioBar/Inicio/Inicio.dart';
import 'MenuNavigatioBar/Inicio/Tutorado/Historial.dart';
import 'MenuNavigatioBar/Notificaciones.dart';
import 'MenuNavigatioBar/Salas/Mision.dart';
import 'MenuNavigatioBar/Salas/Salas.dart';
import 'MenuNavigatioBar/Salas/Tutor/TabPages/SalaVistaTutor.dart';
import 'MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/AddRewardUser.dart';
import 'MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/UserTutorado.dart';
import 'MenuNavigatioBar/Salas/Tutorado/ListMisiones.dart';
import 'Servicios/Autenticacion/DatosNewUser.dart';
import 'Servicios/Autenticacion/EmailPassw/IniciarSessionEmailPassw.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerEmail.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerPassw.dart';
import 'Servicios/Autenticacion/login.dart';
import 'main.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    //Ruta splash screen
    AutoRoute(
        page: MyHomePage,
        name: 'SplashScreenRouter',
        initial: true,
        path: '/EsplashScreen'),
    AutoRoute(page: Login, name: 'LoginRouter', path: '/Login'),
    AutoRoute(
        page: IniSesionEmailPassword,
        name: 'IniSesionEmailPasswordRouter',
        path: '/IniSesionEmailPassword'),
    AutoRoute(page: Roll, name: 'RollRouter', path: '/Roll'),
    AutoRoute(
        page: RecogerEmail, name: 'RecogerEmailRouter', path: '/RecogerEmail'),
    AutoRoute(
        page: NombreUsuario,
        name: 'NombreUsuarioRouter',
        path: '/NombreUsuario'),
    AutoRoute(
        page: RecogerPassw, name: 'RecogerPasswRouter', path: '/RecogerPassw'),
    AutoRoute(
        page: RecoveryPassw, name: 'RecoveryPassw', path: '/RecoveryPassw'),

    //Ruta de main_principal
    AutoRoute(
      path: "/Main",
      name: 'MainRouter',
      page: Main,
      children: [
        //Rutas de home
        AutoRoute(
          path: "Home",
          name: "HomeRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: Home),
            AutoRoute(path: 'Historial', page: Historial),
            AutoRoute(path: 'UserTutoradoDescrip', page: UserTutorado),
            AutoRoute(
                path: 'AddReward', page: AddReward, name: 'AddRewardRouter')
            //AutoRoute(path: ':bookId', page: BookDetailsPage),
            //RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        // our AccountRouter has been moved into the children field

        //RUta de notificaciones
        AutoRoute(
          path: "Notificaciones",
          name: "NotificacionesRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: Notificaciones),
            AutoRoute(page: Mision, path: 'Mision')
            //AutoRoute(path: 'details', page: AccountDetailsPage),
            //RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),

        //Rutas de salas
        AutoRoute(
          path: "Salas",
          name: "SalasRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: Salas),
            AutoRoute(path: 'SalaContVistaTutor', page: SalaContVistaTutor),
            AutoRoute(path: 'UserTutoradoDescrip', page: UserTutorado),
            AutoRoute(
                path: 'ListaMisionesTutorado', page: ListMisionesTutorado),
            AutoRoute(
                path: 'AddReward', page: AddReward, name: 'AddRewardRouter'),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),

        //Rutas de administracioin de perfil
        AutoRoute(
          path: "AdminPerfilUser",
          name: "AdminPerfilUserRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: AdminPerfilUser),
            //AutoRoute(path: 'details', page: AccountDetailsPage),
            //RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
      ],
    ),
  ],
)
class $AppRouter {}

/*
class Rutas {
  static dynamic getRutas() {
    return {
      '/': (context) => const MyHomePage(),
      Login.ROUTE_NAME: (context) => const Login(),
      Roll.ROUTE_NAME: (context) => const Roll(),
      StateNombreUsuario.ROUTE_NAME: (context) => const NombreUsuario(),
      IniSesionEmailPassword.ROUTE_NAME: (context) =>
          const IniSesionEmailPassword(),
      Inicio.ROUTE_NAME: (context) => const Inicio(),
      ListaMisiones.ROUTE_NAME: (context) => const ListaMisiones(),
      TabPagesSala.ROUTE_NAME: (context) => const TabPagesSala(),
      RecogerPassw.ROUTE_NAME: (context) => const RecogerPassw(),
      RecogerEmail.ROUTE_NAME: (context) => const RecogerEmail(),
      IniSesionEmailPassword.ROUTE_NAME: (context) =>
          const IniSesionEmailPassword(),
      UserTutoradoDescrip.ROUTE_NAME: (context) => const UserTutoradoDescrip(),
      Cartera.ROUTE_NAME: (_) => const Cartera()
    };
  }
}
 */
