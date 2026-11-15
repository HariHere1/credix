import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/admin_session.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_shell.dart';

final adminRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: AdminSession.instance,
  redirect: (context, state) {
    final loggedIn = AdminSession.instance.user != null;
    final onLogin = state.matchedLocation == '/login';
    if (!loggedIn && !onLogin) return '/login';
    if (loggedIn && onLogin) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(path:'/login', builder:(context,state)=>const AdminLoginScreen()),
    GoRoute(path:'/dashboard', builder:(context,state)=>const AdminShell(section:'Dashboard')),
    GoRoute(path:'/users', builder:(context,state)=>const AdminShell(section:'Users')),
    GoRoute(path:'/users/:id', builder:(context,state)=>AdminShell(section:'Users',recordId:state.pathParameters['id'])),
    GoRoute(path:'/submissions', builder:(context,state)=>const AdminShell(section:'Submissions')),
    GoRoute(path:'/submissions/:id', builder:(context,state)=>AdminShell(section:'Submissions',recordId:state.pathParameters['id'])),
    GoRoute(path:'/rulebook', builder:(context,state)=>const AdminShell(section:'Rulebook')),
    GoRoute(path:'/audit-log', builder:(context,state)=>const AdminShell(section:'Audit Log')),
    for(final path in ['reports','detection-settings','announcements','academic-year','system-settings'])
      GoRoute(path:'/$path', builder:(context,state)=>AdminShell(section:switch(path){'detection-settings'=>'Detection Settings','academic-year'=>'Academic Year','system-settings'=>'System Settings', _=>path[0].toUpperCase()+path.substring(1)})),
  ],
);

void adminGo(BuildContext context, String section) => context.go(switch(section){'Dashboard'=>'/dashboard','Users'=>'/users','Submissions'=>'/submissions','Rulebook'=>'/rulebook','Audit Log'=>'/audit-log','Reports'=>'/reports','Detection Settings'=>'/detection-settings','Announcements'=>'/announcements','Academic Year'=>'/academic-year',_=>'/system-settings'});
