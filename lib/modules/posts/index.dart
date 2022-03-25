import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:campi/config/index.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/auth/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/modules/posts/feed/index.dart';
import 'package:campi/modules/posts/mgz/index.dart';
import 'package:campi/utils/index.dart';
import 'package:campi/views/router/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_transform/stream_transform.dart';

part './bloc.dart';
part './common.dart';
part './events.dart';
part './repo.dart';

part './state.dart';
