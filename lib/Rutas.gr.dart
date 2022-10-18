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
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:cloud_firestore/cloud_firestore.dart' as _i22;
import 'package:flutter/material.dart' as _i20;

import 'datos/TransferirDatos.dart' as _i21;
import 'main.dart' as _i8;
import 'MenuNavigatioBar/AdminPerfilUser.dart' as _i19;
import 'MenuNavigatioBar/Inicio/Inicio.dart' as _i10;
import 'MenuNavigatioBar/Inicio/Tutorado/Historial.dart' as _i11;
import 'MenuNavigatioBar/Notificaciones.dart' as _i12;
import 'MenuNavigatioBar/Salas/Mision.dart' as _i13;
import 'MenuNavigatioBar/Salas/Salas.dart' as _i14;
import 'MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/AddRewardUser.dart'
    as _i18;
import 'MenuNavigatioBar/Salas/Tutor/TabPages/pages/UsersTutorados/UserTutorado.dart'
    as _i16;
import 'MenuNavigatioBar/Salas/Tutor/TabPages/SalaVistaTutor.dart' as _i15;
import 'MenuNavigatioBar/Salas/Tutorado/ListMisiones.dart' as _i17;
import 'Servicios/Autenticacion/DatosNewUser.dart' as _i4;
import 'Servicios/Autenticacion/EmailPassw/IniciarSessionEmailPassw.dart'
    as _i3;
import 'Servicios/Autenticacion/EmailPassw/RecogerEmail.dart' as _i5;
import 'Servicios/Autenticacion/EmailPassw/RecogerPassw.dart' as _i6;
import 'Servicios/Autenticacion/EmailPassw/RecoverPassw.dart' as _i7;
import 'Servicios/Autenticacion/login.dart' as _i2;
import 'splashScreen.dart' as _i1;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i20.GlobalKey<_i20.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    SplashScreenRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.MyHomePage(),
      );
    },
    LoginRouter.name: (routeData) {
      final args = routeData.argsAs<LoginRouterArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i2.Login(
          key: args.key,
          args: args.args,
        ),
      );
    },
    IniSesionEmailPasswordRouter.name: (routeData) {
      final args = routeData.argsAs<IniSesionEmailPasswordRouterArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.IniSesionEmailPassword(
          key: args.key,
          args: args.args,
        ),
      );
    },
    RollRouter.name: (routeData) {
      final args = routeData.argsAs<RollRouterArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.Roll(
          key: args.key,
          args: args.args,
        ),
      );
    },
    RecogerEmailRouter.name: (routeData) {
      final args = routeData.argsAs<RecogerEmailRouterArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.RecogerEmail(
          key: args.key,
          args: args.args,
        ),
      );
    },
    NombreUsuarioRouter.name: (routeData) {
      final args = routeData.argsAs<NombreUsuarioRouterArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.NombreUsuario(
          key: args.key,
          args: args.args,
        ),
      );
    },
    RecogerPasswRouter.name: (routeData) {
      final args = routeData.argsAs<RecogerPasswRouterArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.RecogerPassw(
          key: args.key,
          args: args.args,
        ),
      );
    },
    RecoveryPassw.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.RecoveryPassw(),
      );
    },
    MainRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.Main(),
      );
    },
    HomeRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.EmptyRouterPage(),
      );
    },
    NotificacionesRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.EmptyRouterPage(),
      );
    },
    SalasRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.EmptyRouterPage(),
      );
    },
    AdminPerfilUserRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.EmptyRouterPage(),
      );
    },
    Home.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.Home(),
      );
    },
    Historial.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i11.Historial(),
      );
    },
    Notificaciones.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.Notificaciones(),
      );
    },
    Mision.name: (routeData) {
      final args = routeData.argsAs<MisionArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i13.Mision(
          key: args.key,
          snap: args.snap,
        ),
      );
    },
    Salas.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i14.Salas(),
      );
    },
    SalaContVistaTutor.name: (routeData) {
      final args = routeData.argsAs<SalaContVistaTutorArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i15.SalaContVistaTutor(
          key: args.key,
          args: args.args,
        ),
      );
    },
    UserTutorado.name: (routeData) {
      final args = routeData.argsAs<UserTutoradoArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i16.UserTutorado(
          key: args.key,
          args: args.args,
        ),
      );
    },
    ListMisionesTutorado.name: (routeData) {
      final args = routeData.argsAs<ListMisionesTutoradoArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i17.ListMisionesTutorado(
          key: args.key,
          args: args.args,
        ),
      );
    },
    AddRewardRouter.name: (routeData) {
      final args = routeData.argsAs<AddRewardRouterArgs>(
          orElse: () => const AddRewardRouterArgs());
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i18.AddReward(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    AdminPerfilUser.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i19.AdminPerfilUser(),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/EsplashScreen',
          fullMatch: true,
        ),
        _i9.RouteConfig(
          SplashScreenRouter.name,
          path: '/EsplashScreen',
        ),
        _i9.RouteConfig(
          LoginRouter.name,
          path: '/Login',
        ),
        _i9.RouteConfig(
          IniSesionEmailPasswordRouter.name,
          path: '/IniSesionEmailPassword',
        ),
        _i9.RouteConfig(
          RollRouter.name,
          path: '/Roll',
        ),
        _i9.RouteConfig(
          RecogerEmailRouter.name,
          path: '/RecogerEmail',
        ),
        _i9.RouteConfig(
          NombreUsuarioRouter.name,
          path: '/NombreUsuario',
        ),
        _i9.RouteConfig(
          RecogerPasswRouter.name,
          path: '/RecogerPassw',
        ),
        _i9.RouteConfig(
          RecoveryPassw.name,
          path: '/RecoveryPassw',
        ),
        _i9.RouteConfig(
          MainRouter.name,
          path: '/Main',
          children: [
            _i9.RouteConfig(
              HomeRouter.name,
              path: 'Home',
              parent: MainRouter.name,
              children: [
                _i9.RouteConfig(
                  Home.name,
                  path: '',
                  parent: HomeRouter.name,
                ),
                _i9.RouteConfig(
                  Historial.name,
                  path: 'Historial',
                  parent: HomeRouter.name,
                ),
              ],
            ),
            _i9.RouteConfig(
              NotificacionesRouter.name,
              path: 'Notificaciones',
              parent: MainRouter.name,
              children: [
                _i9.RouteConfig(
                  Notificaciones.name,
                  path: '',
                  parent: NotificacionesRouter.name,
                ),
                _i9.RouteConfig(
                  Mision.name,
                  path: 'Mision',
                  parent: NotificacionesRouter.name,
                ),
              ],
            ),
            _i9.RouteConfig(
              SalasRouter.name,
              path: 'Salas',
              parent: MainRouter.name,
              children: [
                _i9.RouteConfig(
                  Salas.name,
                  path: '',
                  parent: SalasRouter.name,
                ),
                _i9.RouteConfig(
                  SalaContVistaTutor.name,
                  path: 'SalaContVistaTutor',
                  parent: SalasRouter.name,
                ),
                _i9.RouteConfig(
                  UserTutorado.name,
                  path: 'UserTutoradoDescrip',
                  parent: SalasRouter.name,
                ),
                _i9.RouteConfig(
                  ListMisionesTutorado.name,
                  path: 'ListaMisionesTutorado',
                  parent: SalasRouter.name,
                ),
                _i9.RouteConfig(
                  AddRewardRouter.name,
                  path: 'AddReward',
                  parent: SalasRouter.name,
                ),
                _i9.RouteConfig(
                  '*#redirect',
                  path: '*',
                  parent: SalasRouter.name,
                  redirectTo: '',
                  fullMatch: true,
                ),
              ],
            ),
            _i9.RouteConfig(
              AdminPerfilUserRouter.name,
              path: 'AdminPerfilUser',
              parent: MainRouter.name,
              children: [
                _i9.RouteConfig(
                  AdminPerfilUser.name,
                  path: '',
                  parent: AdminPerfilUserRouter.name,
                )
              ],
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.MyHomePage]
class SplashScreenRouter extends _i9.PageRouteInfo<void> {
  const SplashScreenRouter()
      : super(
          SplashScreenRouter.name,
          path: '/EsplashScreen',
        );

  static const String name = 'SplashScreenRouter';
}

/// generated route for
/// [_i2.Login]
class LoginRouter extends _i9.PageRouteInfo<LoginRouterArgs> {
  LoginRouter({
    _i20.Key? key,
    required _i21.TransferirCollecion args,
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

  final _i20.Key? key;

  final _i21.TransferirCollecion args;

  @override
  String toString() {
    return 'LoginRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i3.IniSesionEmailPassword]
class IniSesionEmailPasswordRouter
    extends _i9.PageRouteInfo<IniSesionEmailPasswordRouterArgs> {
  IniSesionEmailPasswordRouter({
    _i20.Key? key,
    required _i21.TransDatosInicioSesion args,
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

  final _i20.Key? key;

  final _i21.TransDatosInicioSesion args;

  @override
  String toString() {
    return 'IniSesionEmailPasswordRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i4.Roll]
class RollRouter extends _i9.PageRouteInfo<RollRouterArgs> {
  RollRouter({
    _i20.Key? key,
    required _i21.TranferirDatosRoll args,
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

  final _i20.Key? key;

  final _i21.TranferirDatosRoll args;

  @override
  String toString() {
    return 'RollRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i5.RecogerEmail]
class RecogerEmailRouter extends _i9.PageRouteInfo<RecogerEmailRouterArgs> {
  RecogerEmailRouter({
    _i20.Key? key,
    required _i21.TrasnferirDatosNombreUser args,
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

  final _i20.Key? key;

  final _i21.TrasnferirDatosNombreUser args;

  @override
  String toString() {
    return 'RecogerEmailRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i4.NombreUsuario]
class NombreUsuarioRouter extends _i9.PageRouteInfo<NombreUsuarioRouterArgs> {
  NombreUsuarioRouter({
    _i20.Key? key,
    required _i21.TrasnferirDatosNombreUser args,
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

  final _i20.Key? key;

  final _i21.TrasnferirDatosNombreUser args;

  @override
  String toString() {
    return 'NombreUsuarioRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i6.RecogerPassw]
class RecogerPasswRouter extends _i9.PageRouteInfo<RecogerPasswRouterArgs> {
  RecogerPasswRouter({
    _i20.Key? key,
    required _i21.TrasnferirDatosNombreUser args,
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

  final _i20.Key? key;

  final _i21.TrasnferirDatosNombreUser args;

  @override
  String toString() {
    return 'RecogerPasswRouterArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i7.RecoveryPassw]
class RecoveryPassw extends _i9.PageRouteInfo<void> {
  const RecoveryPassw()
      : super(
          RecoveryPassw.name,
          path: '/RecoveryPassw',
        );

  static const String name = 'RecoveryPassw';
}

/// generated route for
/// [_i8.Main]
class MainRouter extends _i9.PageRouteInfo<void> {
  const MainRouter({List<_i9.PageRouteInfo>? children})
      : super(
          MainRouter.name,
          path: '/Main',
          initialChildren: children,
        );

  static const String name = 'MainRouter';
}

/// generated route for
/// [_i9.EmptyRouterPage]
class HomeRouter extends _i9.PageRouteInfo<void> {
  const HomeRouter({List<_i9.PageRouteInfo>? children})
      : super(
          HomeRouter.name,
          path: 'Home',
          initialChildren: children,
        );

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i9.EmptyRouterPage]
class NotificacionesRouter extends _i9.PageRouteInfo<void> {
  const NotificacionesRouter({List<_i9.PageRouteInfo>? children})
      : super(
          NotificacionesRouter.name,
          path: 'Notificaciones',
          initialChildren: children,
        );

  static const String name = 'NotificacionesRouter';
}

/// generated route for
/// [_i9.EmptyRouterPage]
class SalasRouter extends _i9.PageRouteInfo<void> {
  const SalasRouter({List<_i9.PageRouteInfo>? children})
      : super(
          SalasRouter.name,
          path: 'Salas',
          initialChildren: children,
        );

  static const String name = 'SalasRouter';
}

/// generated route for
/// [_i9.EmptyRouterPage]
class AdminPerfilUserRouter extends _i9.PageRouteInfo<void> {
  const AdminPerfilUserRouter({List<_i9.PageRouteInfo>? children})
      : super(
          AdminPerfilUserRouter.name,
          path: 'AdminPerfilUser',
          initialChildren: children,
        );

  static const String name = 'AdminPerfilUserRouter';
}

/// generated route for
/// [_i10.Home]
class Home extends _i9.PageRouteInfo<void> {
  const Home()
      : super(
          Home.name,
          path: '',
        );

  static const String name = 'Home';
}

/// generated route for
/// [_i11.Historial]
class Historial extends _i9.PageRouteInfo<void> {
  const Historial()
      : super(
          Historial.name,
          path: 'Historial',
        );

  static const String name = 'Historial';
}

/// generated route for
/// [_i12.Notificaciones]
class Notificaciones extends _i9.PageRouteInfo<void> {
  const Notificaciones()
      : super(
          Notificaciones.name,
          path: '',
        );

  static const String name = 'Notificaciones';
}

/// generated route for
/// [_i13.Mision]
class Mision extends _i9.PageRouteInfo<MisionArgs> {
  Mision({
    _i20.Key? key,
    required _i22.DocumentSnapshot<Object?> snap,
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

  final _i20.Key? key;

  final _i22.DocumentSnapshot<Object?> snap;

  @override
  String toString() {
    return 'MisionArgs{key: $key, snap: $snap}';
  }
}

/// generated route for
/// [_i14.Salas]
class Salas extends _i9.PageRouteInfo<void> {
  const Salas()
      : super(
          Salas.name,
          path: '',
        );

  static const String name = 'Salas';
}

/// generated route for
/// [_i15.SalaContVistaTutor]
class SalaContVistaTutor extends _i9.PageRouteInfo<SalaContVistaTutorArgs> {
  SalaContVistaTutor({
    _i20.Key? key,
    required _i21.TransferirDatos args,
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

  final _i20.Key? key;

  final _i21.TransferirDatos args;

  @override
  String toString() {
    return 'SalaContVistaTutorArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i16.UserTutorado]
class UserTutorado extends _i9.PageRouteInfo<UserTutoradoArgs> {
  UserTutorado({
    _i20.Key? key,
    required _i21.TransfDatosUserTutorado args,
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

  final _i20.Key? key;

  final _i21.TransfDatosUserTutorado args;

  @override
  String toString() {
    return 'UserTutoradoArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i17.ListMisionesTutorado]
class ListMisionesTutorado extends _i9.PageRouteInfo<ListMisionesTutoradoArgs> {
  ListMisionesTutorado({
    _i20.Key? key,
    required _i21.TransferirDatos args,
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

  final _i20.Key? key;

  final _i21.TransferirDatos args;

  @override
  String toString() {
    return 'ListMisionesTutoradoArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i18.AddReward]
class AddRewardRouter extends _i9.PageRouteInfo<AddRewardRouterArgs> {
  AddRewardRouter({
    _i20.Key? key,
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

  final _i20.Key? key;

  final dynamic userId;

  @override
  String toString() {
    return 'AddRewardRouterArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i19.AdminPerfilUser]
class AdminPerfilUser extends _i9.PageRouteInfo<void> {
  const AdminPerfilUser()
      : super(
          AdminPerfilUser.name,
          path: '',
        );

  static const String name = 'AdminPerfilUser';
}
