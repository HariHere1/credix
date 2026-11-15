import 'package:flutter/material.dart';
import 'admin_router.dart';

import 'admin_theme.dart';

class CredixAdminApp extends StatelessWidget {
  const CredixAdminApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Credix Admin',
        debugShowCheckedModeBanner: false,
        theme: buildAdminTheme(),
        routerConfig: adminRouter,
      );
}
