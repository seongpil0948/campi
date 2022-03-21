import 'dart:convert';

import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/modules/posts/feed/index.dart';
import 'package:campi/modules/posts/index.dart';
import 'package:campi/modules/posts/mgz/index.dart';
import 'package:campi/utils/index.dart';
import 'package:campi/views/router/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

part './model.dart';
part './repo.dart';
part './user_repo.dart';
part './login/cubit.dart';
part './login/state.dart';
