import 'dart:convert';

import 'package:campi/modules/auth/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/utils/index.dart';
import 'package:campi/views/router/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

import '../index.dart';

part './cubit.dart';
part './state.dart';
