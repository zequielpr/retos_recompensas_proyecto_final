import 'package:auto_route/empty_router_widgets.dart';
import 'package:retos_proyecto/MenuNavigatioBar/Perfil/AdminPerfilUser.dart';
import 'package:retos_proyecto/Servicios/Autenticacion/EmailPassw/RecoverPassw.dart';
import 'package:retos_proyecto/datos/Roll_Data.dart';
import 'package:retos_proyecto/main.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'MenuNavigatioBar/Inicio/Inicio.dart';
import 'MenuNavigatioBar/Inicio/Tutorado/Historial.dart';
import 'MenuNavigatioBar/Notificaciones.dart';
import 'MenuNavigatioBar/Perfil/admin_cuenta/Admin_cuenta.dart';
import 'MenuNavigatioBar/Perfil/admin_cuenta/ModificarEmail.dart';
import 'MenuNavigatioBar/Perfil/admin_cuenta/change_password.dart';
import 'MenuNavigatioBar/Perfil/editar_perfil/Editar_perfil.dart';
import 'MenuNavigatioBar/Perfil/editar_perfil/ModificarNombre.dart';
import 'MenuNavigatioBar/Perfil/editar_perfil/ModificarNombreUsuario.dart';
import 'MenuNavigatioBar/Salas/Mision.dart';
import 'MenuNavigatioBar/Salas/Salas.dart';
import 'MenuNavigatioBar/Salas/Tutor/SalaVistaTutor.dart';
import 'MenuNavigatioBar/Salas/Tutor/TabPages/pages/Misiones.dart';
import 'MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/AddRewardUser.dart';
import 'MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/UserTutorado.dart';
import 'MenuNavigatioBar/Salas/Tutorado/ListMisiones.dart';
import 'Servicios/Autenticacion/DatosNewUser.dart';
import 'Servicios/Autenticacion/EmailPassw/InfoVerificacionEmail.dart';
import 'Servicios/Autenticacion/EmailPassw/IniciarSessionEmailPassw.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerEmail.dart';
import 'Servicios/Autenticacion/EmailPassw/RecogerPassw/RecogerPassw.dart';
import 'Servicios/Autenticacion/login.dart';
import 'MenuNavigatioBar/menu.dart';
import 'onboarding/onboarding.dart';

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
    AutoRoute(page: InfoVerificacionEmail, name: 'InfoVerificacionEmailRouter', path: '/InfoVerificacionEmail'),
    AutoRoute(page: Onboarding, name: 'OnboadingRouter', path: '/Onboading'),
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
          ],
        ),

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
            AutoRoute(path: 'AddMision', page: AddMision, name: 'AddMisionRouter'),
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
            AutoRoute(
                path: 'ChangePasswd', page: ChangePasswd, name: 'ChangePasswdRouter'),
            AutoRoute(path:'EditarPerfil', page: EditarPerfil, name: 'EditarPerfilRouter' ),
            AutoRoute(path: 'AdminCuenta', page: AdminCuenta, name: 'AdminCuentaRoute'),
            AutoRoute(path: 'ModificarEmail', page: ModificarEmail, name: 'ModificarEmailRouter'),
            AutoRoute(path: 'ModificarNombre', page: ModificarNombre, name: 'ModificarNombreRouter'),
            AutoRoute(path: 'ModificarNombreUsuario', page: ModificarNombreUsuario, name: 'ModificarNombreUsuarioRouter'),
            //AutoRoute(path: 'details', page: AccountDetailsPage),
            RedirectRoute(path: '*', redirectTo: ''),
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
