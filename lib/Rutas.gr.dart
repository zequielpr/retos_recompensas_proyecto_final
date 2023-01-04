// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i28;
import 'package:auto_route/empty_router_widgets.dart' as _i10;
import 'package:cloud_firestore/cloud_firestore.dart' as _i31;
import 'package:flutter/material.dart' as _i29;

import 'datos/TransferirDatos.dart' as _i30;
import 'main.dart' as _i9;
import 'MenuNavigatioBar/Inicio/Inicio.dart' as _i11;
import 'MenuNavigatioBar/Inicio/Tutorado/Historial.dart' as _i12;
import 'MenuNavigatioBar/Notificaciones.dart' as _i15;
import 'MenuNavigatioBar/Perfil/admin_cuenta/Admin_cuenta.dart' as _i24;
import 'MenuNavigatioBar/Perfil/admin_cuenta/change_password.dart' as _i22;
import 'MenuNavigatioBar/Perfil/admin_cuenta/ModificarEmail.dart' as _i25;
import 'MenuNavigatioBar/Perfil/AdminPerfilUser.dart' as _i21;
import 'MenuNavigatioBar/Perfil/editar_perfil/Editar_perfil.dart' as _i23;
import 'MenuNavigatioBar/Perfil/editar_perfil/ModificarNombre.dart' as _i26;
import 'MenuNavigatioBar/Perfil/editar_perfil/ModificarNombreUsuario.dart'
    as _i27;
import 'MenuNavigatioBar/Salas/Mision.dart' as _i16;
import 'MenuNavigatioBar/Salas/Salas.dart' as _i17;
import 'MenuNavigatioBar/Salas/Tutor/SalaVistaTutor.dart' as _i18;
import 'MenuNavigatioBar/Salas/Tutor/TabPages/pages/Misiones.dart' as _i19;
import 'MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/AddRewardUser.dart'
    as _i14;
import 'MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/UserTutorado.dart'
    as _i13;
import 'MenuNavigatioBar/Salas/Tutorado/ListMisiones.dart' as _i20;
import 'Servicios/Autenticacion/DatosNewUser.dart' as _i4;
import 'Servicios/Autenticacion/EmailPassw/InfoVerificacionEmail.dart' as _i8;
import 'Servicios/Autenticacion/EmailPassw/IniciarSessionEmailPassw.dart'
    as _i3;
import 'Servicios/Autenticacion/EmailPassw/RecogerEmail.dart' as _i5;
import 'Servicios/Autenticacion/EmailPassw/RecogerPassw.dart' as _i6;
import 'Servicios/Autenticacion/EmailPassw/RecoverPassw.dart' as _i7;
import 'Servicios/Autenticacion/login.dart' as _i2;
import 'splashScreen.dart' as _i1;

class AppRouter extends _i28.RootStackRouter {
  AppRouter([_i29.GlobalKey<_i29.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i28.PageFactory> pagesMap = {
    SplashScreenRouter.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.MyHomePage(),
      );
    },
    LoginRouter.name: (routeData) {
      final args = routeData.argsAs<LoginRouterArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i2.Login(
          key: args.key,
          args: args.args,
        ),
      );
    },
    IniSesionEmailPasswordRouter.name: (routeData) {
      final args = routeData.argsAs<IniSesionEmailPasswordRouterArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.IniSesionEmailPassword(
          key: args.key,
          args: args.args,
        ),
      );
    },
    RollRouter.name: (routeData) {
      final args = routeData.argsAs<RollRouterArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.Roll(
          key: args.key,
          args: args.args,
        ),
      );
    },
    RecogerEmailRouter.name: (routeData) {
      final args = routeData.argsAs<RecogerEmailRouterArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.RecogerEmail(
          key: args.key,
          args: args.args,
        ),
      );
    },
    NombreUsuarioRouter.name: (routeData) {
      final args = routeData.argsAs<NombreUsuarioRouterArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.NombreUsuario(
          key: args.key,
          args: args.args,
        ),
      );
    },
    RecogerPasswRouter.name: (routeData) {
      final args = routeData.argsAs<RecogerPasswRouterArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.RecogerPassw(
          key: args.key,
          args: args.args,
        ),
      );
    },
    RecoveryPassw.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.RecoveryPassw(),
      );
    },
    InfoVerificacionEmailRouter.name: (routeData) {
      final args = routeData.argsAs<InfoVerificacionEmailRouterArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.InfoVerificacionEmail(
          key: args.key,
          arg: args.arg,
        ),
      );
    },
    MainRouter.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.Main(),
      );
    },
    HomeRouter.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.EmptyRouterPage(),
      );
    },
    NotificacionesRouter.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.EmptyRouterPage(),
      );
    },
    SalasRouter.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.EmptyRouterPage(),
      );
    },
    AdminPerfilUserRouter.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.EmptyRouterPage(),
      );
    },
    Home.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i11.Home(),
      );
    },
    Historial.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.Historial(),
      );
    },
    UserTutorado.name: (routeData) {
      final args = routeData.argsAs<UserTutoradoArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i13.UserTutorado(
          key: args.key,
          args: args.args,
        ),
      );
    },
    AddRewardRouter.name: (routeData) {
      final args = routeData.argsAs<AddRewardRouterArgs>(
          orElse: () => const AddRewardRouterArgs());
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i14.AddReward(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    Notificaciones.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i15.Notificaciones(),
      );
    },
    Mision.name: (routeData) {
      final args = routeData.argsAs<MisionArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i16.Mision(
          key: args.key,
          snap: args.snap,
        ),
      );
    },
    Salas.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i17.Salas(),
      );
    },
    SalaContVistaTutor.name: (routeData) {
      final args = routeData.argsAs<SalaContVistaTutorArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i18.SalaContVistaTutor(
          key: args.key,
          args: args.args,
        ),
      );
    },
    AddMisionRouter.name: (routeData) {
      final args = routeData.argsAs<AddMisionRouterArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i19.AddMision(
          key: args.key,
          collectionReferenceMisiones: args.collectionReferenceMisiones,
          contextSala: args.contextSala,
        ),
      );
    },
    ListMisionesTutorado.name: (routeData) {
      final args = routeData.argsAs<ListMisionesTutoradoArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i20.ListMisionesTutorado(
          key: args.key,
          args: args.args,
        ),
      );
    },
    AdminPerfilUser.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i21.AdminPerfilUser(),
      );
    },
    ChangePasswdRouter.name: (routeData) {
      final args = routeData.argsAs<ChangePasswdRouterArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i22.ChangePasswd(
          key: args.key,
          contextPerfil: args.contextPerfil,
        ),
      );
    },
    EditarPerfilRouter.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i23.EditarPerfil(),
      );
    },
    AdminCuentaRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i24.AdminCuenta(),
      );
    },
    ModificarEmailRouter.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i25.ModificarEmail(),
      );
    },
    ModificarNombreRouter.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i26.ModificarNombre(),
      );
    },
    ModificarNombreUsuarioRouter.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i27.ModificarNombreUsuario(),
      );
    },
  };

  @override
  List<_i28.RouteConfig> get routes => [
        _i28.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/EsplashScreen',
          fullMatch: true,
        ),
        _i28.RouteConfig(
          SplashScreenRouter.name,
          path: '/EsplashScreen',
        ),
        _i28.RouteConfig(
          LoginRouter.name,
          path: '/Login',
        ),
        _i28.RouteConfig(
          IniSesionEmailPasswordRouter.name,
          path: '/IniSesionEmailPassword',
        ),
        _i28.RouteConfig(
          RollRouter.name,
          path: '/Roll',
        ),
        _i28.RouteConfig(
          RecogerEmailRouter.name,
          path: '/RecogerEmail',
        ),
        _i28.RouteConfig(
          NombreUsuarioRouter.name,
          path: '/NombreUsuario',
        ),
        _i28.RouteConfig(
          RecogerPasswRouter.name,
          path: '/RecogerPassw',
        ),
        _i28.RouteConfig(
          RecoveryPassw.name,
          path: '/RecoveryPassw',
        ),
        _i28.RouteConfig(
          InfoVerificacionEmailRouter.name,
          path: '/InfoVerificacionEmail',
        ),
        _i28.RouteConfig(
          MainRouter.name,
          path: '/Main',
          children: [
            _i28.RouteConfig(
              HomeRouter.name,
              path: 'Home',
              parent: MainRouter.name,
              children: [
                _i28.RouteConfig(
                  Home.name,
                  path: '',
                  parent: HomeRouter.name,
                ),
                _i28.RouteConfig(
                  Historial.name,
                  path: 'Historial',
                  parent: HomeRouter.name,
                ),
                _i28.RouteConfig(
                  UserTutorado.name,
                  path: 'UserTutoradoDescrip',
                  parent: HomeRouter.name,
                ),
                _i28.RouteConfig(
                  AddRewardRouter.name,
                  path: 'AddReward',
                  parent: HomeRouter.name,
                ),
              ],
            ),
            _i28.RouteConfig(
              NotificacionesRouter.name,
              path: 'Notificaciones',
              parent: MainRouter.name,
              children: [
                _i28.RouteConfig(
                  Notificaciones.name,
                  path: '',
                  parent: NotificacionesRouter.name,
                ),
                _i28.RouteConfig(
                  Mision.name,
                  path: 'Mision',
                  parent: NotificacionesRouter.name,
                ),
              ],
            ),
            _i28.RouteConfig(
              SalasRouter.name,
              path: 'Salas',
              parent: MainRouter.name,
              children: [
                _i28.RouteConfig(
                  Salas.name,
                  path: '',
                  parent: SalasRouter.name,
                ),
                _i28.RouteConfig(
                  SalaContVistaTutor.name,
                  path: 'SalaContVistaTutor',
                  parent: SalasRouter.name,
                ),
                _i28.RouteConfig(
                  UserTutorado.name,
                  path: 'UserTutoradoDescrip',
                  parent: SalasRouter.name,
                ),
                _i28.RouteConfig(
                  AddMisionRouter.name,
                  path: 'AddMision',
                  parent: SalasRouter.name,
                ),
                _i28.RouteConfig(
                  ListMisionesTutorado.name,
                  path: 'ListaMisionesTutorado',
                  parent: SalasRouter.name,
                ),
                _i28.RouteConfig(
                  AddRewardRouter.name,
                  path: 'AddReward',
                  parent: SalasRouter.name,
                ),
                _i28.RouteConfig(
                  '*#redirect',
                  path: '*',
                  parent: SalasRouter.name,
                  redirectTo: '',
                  fullMatch: true,
                ),
              ],
            ),
            _i28.RouteConfig(
              AdminPerfilUserRouter.name,
              path: 'AdminPerfilUser',
              parent: MainRouter.name,
              children: [
                _i28.RouteConfig(
                  AdminPerfilUser.name,
                  path: '',
                  parent: AdminPerfilUserRouter.name,
                ),
                _i28.RouteConfig(
                  ChangePasswdRouter.name,
                  path: 'ChangePasswd',
                  parent: AdminPerfilUserRouter.name,
                ),
                _i28.RouteConfig(
                  EditarPerfilRouter.name,
                  path: 'EditarPerfil',
                  parent: AdminPerfilUserRouter.name,
                ),
                _i28.RouteConfig(
                  AdminCuentaRoute.name,
                  path: 'AdminCuenta',
                  parent: AdminPerfilUserRouter.name,
                ),
                _i28.RouteConfig(
                  ModificarEmailRouter.name,
                  path: 'ModificarEmail',
                  parent: AdminPerfilUserRouter.name,
                ),
                _i28.RouteConfig(
                  ModificarNombreRouter.name,
                  path: 'ModificarNombre',
                  parent: AdminPerfilUserRouter.name,
                ),
                _i28.RouteConfig(
                  ModificarNombreUsuarioRouter.name,
                  path: 'ModificarNombreUsuario',
                  parent: AdminPerfilUserRouter.name,
                ),
                _i28.RouteConfig(
                  '*#redirect',
                  path: '*',
                  parent: AdminPerfilUserRouter.name,
                  redirectTo: '',
                  fullMatch: true,
                ),
              ],
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.MyHomePage]
class SplashScreenRouter extends _i28.PageRouteInfo<void> {
  const SplashScreenRouter()
      : super(
          SplashScreenRouter.name,
          path: '/EsplashScreen',
        );

  static const String name = 'SplashScreenRouter';
}

/// generated route for
/// [_i2.Login]
class LoginRouter extends _i28.PageRouteInfo<LoginRouterArgs> {
  LoginRouter({
    _i29.Key? key,
    required _i30.TransferirCollecion args,
  }) : super(
          LoginRouter.name,
          path: '/Login',
          args: LoginRouterArgs(
            key: key,
            args: args,
          ),
        );

  static const String name = 'LoginRouter';
}

class LoginRouterArgs {
  const LoginRouterArgs({
    this.key,
    required this.args,
  });

  final _i29.Key? key;

  final _i30.TransferirCollecion args;

  @override
  String toString() {
    return 'LoginRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i3.IniSesionEmailPassword]
class IniSesionEmailPasswordRouter
    extends _i28.PageRouteInfo<IniSesionEmailPasswordRouterArgs> {
  IniSesionEmailPasswordRouter({
    _i29.Key? key,
    required _i30.TransDatosInicioSesion args,
  }) : super(
          IniSesionEmailPasswordRouter.name,
          path: '/IniSesionEmailPassword',
          args: IniSesionEmailPasswordRouterArgs(
            key: key,
            args: args,
          ),
        );

  static const String name = 'IniSesionEmailPasswordRouter';
}

class IniSesionEmailPasswordRouterArgs {
  const IniSesionEmailPasswordRouterArgs({
    this.key,
    required this.args,
  });

  final _i29.Key? key;

  final _i30.TransDatosInicioSesion args;

  @override
  String toString() {
    return 'IniSesionEmailPasswordRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i4.Roll]
class RollRouter extends _i28.PageRouteInfo<RollRouterArgs> {
  RollRouter({
    _i29.Key? key,
    required _i30.TranferirDatosRoll args,
  }) : super(
          RollRouter.name,
          path: '/Roll',
          args: RollRouterArgs(
            key: key,
            args: args,
          ),
        );

  static const String name = 'RollRouter';
}

class RollRouterArgs {
  const RollRouterArgs({
    this.key,
    required this.args,
  });

  final _i29.Key? key;

  final _i30.TranferirDatosRoll args;

  @override
  String toString() {
    return 'RollRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i5.RecogerEmail]
class RecogerEmailRouter extends _i28.PageRouteInfo<RecogerEmailRouterArgs> {
  RecogerEmailRouter({
    _i29.Key? key,
    required _i30.TrasnferirDatosNombreUser args,
  }) : super(
          RecogerEmailRouter.name,
          path: '/RecogerEmail',
          args: RecogerEmailRouterArgs(
            key: key,
            args: args,
          ),
        );

  static const String name = 'RecogerEmailRouter';
}

class RecogerEmailRouterArgs {
  const RecogerEmailRouterArgs({
    this.key,
    required this.args,
  });

  final _i29.Key? key;

  final _i30.TrasnferirDatosNombreUser args;

  @override
  String toString() {
    return 'RecogerEmailRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i4.NombreUsuario]
class NombreUsuarioRouter extends _i28.PageRouteInfo<NombreUsuarioRouterArgs> {
  NombreUsuarioRouter({
    _i29.Key? key,
    required _i30.TrasnferirDatosNombreUser args,
  }) : super(
          NombreUsuarioRouter.name,
          path: '/NombreUsuario',
          args: NombreUsuarioRouterArgs(
            key: key,
            args: args,
          ),
        );

  static const String name = 'NombreUsuarioRouter';
}

class NombreUsuarioRouterArgs {
  const NombreUsuarioRouterArgs({
    this.key,
    required this.args,
  });

  final _i29.Key? key;

  final _i30.TrasnferirDatosNombreUser args;

  @override
  String toString() {
    return 'NombreUsuarioRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i6.RecogerPassw]
class RecogerPasswRouter extends _i28.PageRouteInfo<RecogerPasswRouterArgs> {
  RecogerPasswRouter({
    _i29.Key? key,
    required _i30.TrasnferirDatosNombreUser args,
  }) : super(
          RecogerPasswRouter.name,
          path: '/RecogerPassw',
          args: RecogerPasswRouterArgs(
            key: key,
            args: args,
          ),
        );

  static const String name = 'RecogerPasswRouter';
}

class RecogerPasswRouterArgs {
  const RecogerPasswRouterArgs({
    this.key,
    required this.args,
  });

  final _i29.Key? key;

  final _i30.TrasnferirDatosNombreUser args;

  @override
  String toString() {
    return 'RecogerPasswRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i7.RecoveryPassw]
class RecoveryPassw extends _i28.PageRouteInfo<void> {
  const RecoveryPassw()
      : super(
          RecoveryPassw.name,
          path: '/RecoveryPassw',
        );

  static const String name = 'RecoveryPassw';
}

/// generated route for
/// [_i8.InfoVerificacionEmail]
class InfoVerificacionEmailRouter
    extends _i28.PageRouteInfo<InfoVerificacionEmailRouterArgs> {
  InfoVerificacionEmailRouter({
    _i29.Key? key,
    required _i30.TransDatosInicioSesion arg,
  }) : super(
          InfoVerificacionEmailRouter.name,
          path: '/InfoVerificacionEmail',
          args: InfoVerificacionEmailRouterArgs(
            key: key,
            arg: arg,
          ),
        );

  static const String name = 'InfoVerificacionEmailRouter';
}

class InfoVerificacionEmailRouterArgs {
  const InfoVerificacionEmailRouterArgs({
    this.key,
    required this.arg,
  });

  final _i29.Key? key;

  final _i30.TransDatosInicioSesion arg;

  @override
  String toString() {
    return 'InfoVerificacionEmailRouterArgs{key: $key, arg: $arg}';
  }
}

/// generated route for
/// [_i9.Main]
class MainRouter extends _i28.PageRouteInfo<void> {
  const MainRouter({List<_i28.PageRouteInfo>? children})
      : super(
          MainRouter.name,
          path: '/Main',
          initialChildren: children,
        );

  static const String name = 'MainRouter';
}

/// generated route for
/// [_i10.EmptyRouterPage]
class HomeRouter extends _i28.PageRouteInfo<void> {
  const HomeRouter({List<_i28.PageRouteInfo>? children})
      : super(
          HomeRouter.name,
          path: 'Home',
          initialChildren: children,
        );

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i10.EmptyRouterPage]
class NotificacionesRouter extends _i28.PageRouteInfo<void> {
  const NotificacionesRouter({List<_i28.PageRouteInfo>? children})
      : super(
          NotificacionesRouter.name,
          path: 'Notificaciones',
          initialChildren: children,
        );

  static const String name = 'NotificacionesRouter';
}

/// generated route for
/// [_i10.EmptyRouterPage]
class SalasRouter extends _i28.PageRouteInfo<void> {
  const SalasRouter({List<_i28.PageRouteInfo>? children})
      : super(
          SalasRouter.name,
          path: 'Salas',
          initialChildren: children,
        );

  static const String name = 'SalasRouter';
}

/// generated route for
/// [_i10.EmptyRouterPage]
class AdminPerfilUserRouter extends _i28.PageRouteInfo<void> {
  const AdminPerfilUserRouter({List<_i28.PageRouteInfo>? children})
      : super(
          AdminPerfilUserRouter.name,
          path: 'AdminPerfilUser',
          initialChildren: children,
        );

  static const String name = 'AdminPerfilUserRouter';
}

/// generated route for
/// [_i11.Home]
class Home extends _i28.PageRouteInfo<void> {
  const Home()
      : super(
          Home.name,
          path: '',
        );

  static const String name = 'Home';
}

/// generated route for
/// [_i12.Historial]
class Historial extends _i28.PageRouteInfo<void> {
  const Historial()
      : super(
          Historial.name,
          path: 'Historial',
        );

  static const String name = 'Historial';
}

/// generated route for
/// [_i13.UserTutorado]
class UserTutorado extends _i28.PageRouteInfo<UserTutoradoArgs> {
  UserTutorado({
    _i29.Key? key,
    required _i30.TransfDatosUserTutorado args,
  }) : super(
          UserTutorado.name,
          path: 'UserTutoradoDescrip',
          args: UserTutoradoArgs(
            key: key,
            args: args,
          ),
        );

  static const String name = 'UserTutorado';
}

class UserTutoradoArgs {
  const UserTutoradoArgs({
    this.key,
    required this.args,
  });

  final _i29.Key? key;

  final _i30.TransfDatosUserTutorado args;

  @override
  String toString() {
    return 'UserTutoradoArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i14.AddReward]
class AddRewardRouter extends _i28.PageRouteInfo<AddRewardRouterArgs> {
  AddRewardRouter({
    _i29.Key? key,
    dynamic userId,
  }) : super(
          AddRewardRouter.name,
          path: 'AddReward',
          args: AddRewardRouterArgs(
            key: key,
            userId: userId,
          ),
        );

  static const String name = 'AddRewardRouter';
}

class AddRewardRouterArgs {
  const AddRewardRouterArgs({
    this.key,
    this.userId,
  });

  final _i29.Key? key;

  final dynamic userId;

  @override
  String toString() {
    return 'AddRewardRouterArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i15.Notificaciones]
class Notificaciones extends _i28.PageRouteInfo<void> {
  const Notificaciones()
      : super(
          Notificaciones.name,
          path: '',
        );

  static const String name = 'Notificaciones';
}

/// generated route for
/// [_i16.Mision]
class Mision extends _i28.PageRouteInfo<MisionArgs> {
  Mision({
    _i29.Key? key,
    required _i31.DocumentSnapshot<Object?> snap,
  }) : super(
          Mision.name,
          path: 'Mision',
          args: MisionArgs(
            key: key,
            snap: snap,
          ),
        );

  static const String name = 'Mision';
}

class MisionArgs {
  const MisionArgs({
    this.key,
    required this.snap,
  });

  final _i29.Key? key;

  final _i31.DocumentSnapshot<Object?> snap;

  @override
  String toString() {
    return 'MisionArgs{key: $key, snap: $snap}';
  }
}

/// generated route for
/// [_i17.Salas]
class Salas extends _i28.PageRouteInfo<void> {
  const Salas()
      : super(
          Salas.name,
          path: '',
        );

  static const String name = 'Salas';
}

/// generated route for
/// [_i18.SalaContVistaTutor]
class SalaContVistaTutor extends _i28.PageRouteInfo<SalaContVistaTutorArgs> {
  SalaContVistaTutor({
    _i29.Key? key,
    required _i30.TransferirDatos args,
  }) : super(
          SalaContVistaTutor.name,
          path: 'SalaContVistaTutor',
          args: SalaContVistaTutorArgs(
            key: key,
            args: args,
          ),
        );

  static const String name = 'SalaContVistaTutor';
}

class SalaContVistaTutorArgs {
  const SalaContVistaTutorArgs({
    this.key,
    required this.args,
  });

  final _i29.Key? key;

  final _i30.TransferirDatos args;

  @override
  String toString() {
    return 'SalaContVistaTutorArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i19.AddMision]
class AddMisionRouter extends _i28.PageRouteInfo<AddMisionRouterArgs> {
  AddMisionRouter({
    _i29.Key? key,
    required _i31.CollectionReference<Object?> collectionReferenceMisiones,
    required _i29.BuildContext contextSala,
  }) : super(
          AddMisionRouter.name,
          path: 'AddMision',
          args: AddMisionRouterArgs(
            key: key,
            collectionReferenceMisiones: collectionReferenceMisiones,
            contextSala: contextSala,
          ),
        );

  static const String name = 'AddMisionRouter';
}

class AddMisionRouterArgs {
  const AddMisionRouterArgs({
    this.key,
    required this.collectionReferenceMisiones,
    required this.contextSala,
  });

  final _i29.Key? key;

  final _i31.CollectionReference<Object?> collectionReferenceMisiones;

  final _i29.BuildContext contextSala;

  @override
  String toString() {
    return 'AddMisionRouterArgs{key: $key, collectionReferenceMisiones: $collectionReferenceMisiones, contextSala: $contextSala}';
  }
}

/// generated route for
/// [_i20.ListMisionesTutorado]
class ListMisionesTutorado
    extends _i28.PageRouteInfo<ListMisionesTutoradoArgs> {
  ListMisionesTutorado({
    _i29.Key? key,
    required _i30.TransferirDatos args,
  }) : super(
          ListMisionesTutorado.name,
          path: 'ListaMisionesTutorado',
          args: ListMisionesTutoradoArgs(
            key: key,
            args: args,
          ),
        );

  static const String name = 'ListMisionesTutorado';
}

class ListMisionesTutoradoArgs {
  const ListMisionesTutoradoArgs({
    this.key,
    required this.args,
  });

  final _i29.Key? key;

  final _i30.TransferirDatos args;

  @override
  String toString() {
    return 'ListMisionesTutoradoArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i21.AdminPerfilUser]
class AdminPerfilUser extends _i28.PageRouteInfo<void> {
  const AdminPerfilUser()
      : super(
          AdminPerfilUser.name,
          path: '',
        );

  static const String name = 'AdminPerfilUser';
}

/// generated route for
/// [_i22.ChangePasswd]
class ChangePasswdRouter extends _i28.PageRouteInfo<ChangePasswdRouterArgs> {
  ChangePasswdRouter({
    _i29.Key? key,
    required _i29.BuildContext contextPerfil,
  }) : super(
          ChangePasswdRouter.name,
          path: 'ChangePasswd',
          args: ChangePasswdRouterArgs(
            key: key,
            contextPerfil: contextPerfil,
          ),
        );

  static const String name = 'ChangePasswdRouter';
}

class ChangePasswdRouterArgs {
  const ChangePasswdRouterArgs({
    this.key,
    required this.contextPerfil,
  });

  final _i29.Key? key;

  final _i29.BuildContext contextPerfil;

  @override
  String toString() {
    return 'ChangePasswdRouterArgs{key: $key, contextPerfil: $contextPerfil}';
  }
}

/// generated route for
/// [_i23.EditarPerfil]
class EditarPerfilRouter extends _i28.PageRouteInfo<void> {
  const EditarPerfilRouter()
      : super(
          EditarPerfilRouter.name,
          path: 'EditarPerfil',
        );

  static const String name = 'EditarPerfilRouter';
}

/// generated route for
/// [_i24.AdminCuenta]
class AdminCuentaRoute extends _i28.PageRouteInfo<void> {
  const AdminCuentaRoute()
      : super(
          AdminCuentaRoute.name,
          path: 'AdminCuenta',
        );

  static const String name = 'AdminCuentaRoute';
}

/// generated route for
/// [_i25.ModificarEmail]
class ModificarEmailRouter extends _i28.PageRouteInfo<void> {
  const ModificarEmailRouter()
      : super(
          ModificarEmailRouter.name,
          path: 'ModificarEmail',
        );

  static const String name = 'ModificarEmailRouter';
}

/// generated route for
/// [_i26.ModificarNombre]
class ModificarNombreRouter extends _i28.PageRouteInfo<void> {
  const ModificarNombreRouter()
      : super(
          ModificarNombreRouter.name,
          path: 'ModificarNombre',
        );

  static const String name = 'ModificarNombreRouter';
}

/// generated route for
/// [_i27.ModificarNombreUsuario]
class ModificarNombreUsuarioRouter extends _i28.PageRouteInfo<void> {
  const ModificarNombreUsuarioRouter()
      : super(
          ModificarNombreUsuarioRouter.name,
          path: 'ModificarNombreUsuario',
        );

  static const String name = 'ModificarNombreUsuarioRouter';
}
