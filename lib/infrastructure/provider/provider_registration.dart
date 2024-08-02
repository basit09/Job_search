import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_search/infrastructure/provider/job_provider.dart';

import 'auth_provider.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((_) => AuthProvider());
final jobProvider = ChangeNotifierProvider<JobProvider>((_) => JobProvider());
