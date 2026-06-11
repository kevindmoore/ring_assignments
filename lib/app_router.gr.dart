// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i3;
import 'package:ring_assignments/pages.dart' as _i1;

/// generated route for
/// [_i1.AssignmentShellPage]
class AssignmentShellRoute extends _i2.PageRouteInfo<void> {
  const AssignmentShellRoute({List<_i2.PageRouteInfo>? children})
    : super(AssignmentShellRoute.name, initialChildren: children);

  static const String name = 'AssignmentShellRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      return const _i1.AssignmentShellPage();
    },
  );
}

/// generated route for
/// [_i1.AssignmentsPage]
class AssignmentsRoute extends _i2.PageRouteInfo<void> {
  const AssignmentsRoute({List<_i2.PageRouteInfo>? children})
    : super(AssignmentsRoute.name, initialChildren: children);

  static const String name = 'AssignmentsRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      return const _i1.AssignmentsPage();
    },
  );
}

/// generated route for
/// [_i1.CompetitorsPage]
class CompetitorsRoute extends _i2.PageRouteInfo<void> {
  const CompetitorsRoute({List<_i2.PageRouteInfo>? children})
    : super(CompetitorsRoute.name, initialChildren: children);

  static const String name = 'CompetitorsRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      return const _i1.CompetitorsPage();
    },
  );
}

/// generated route for
/// [_i1.JudgeEditorPage]
class JudgeEditorRoute extends _i2.PageRouteInfo<JudgeEditorRouteArgs> {
  JudgeEditorRoute({
    _i3.Key? key,
    String? judgeId,
    List<_i2.PageRouteInfo>? children,
  }) : super(
         JudgeEditorRoute.name,
         args: JudgeEditorRouteArgs(key: key, judgeId: judgeId),
         initialChildren: children,
       );

  static const String name = 'JudgeEditorRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<JudgeEditorRouteArgs>(
        orElse: () => const JudgeEditorRouteArgs(),
      );
      return _i1.JudgeEditorPage(key: args.key, judgeId: args.judgeId);
    },
  );
}

class JudgeEditorRouteArgs {
  const JudgeEditorRouteArgs({this.key, this.judgeId});

  final _i3.Key? key;

  final String? judgeId;

  @override
  String toString() {
    return 'JudgeEditorRouteArgs{key: $key, judgeId: $judgeId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! JudgeEditorRouteArgs) return false;
    return key == other.key && judgeId == other.judgeId;
  }

  @override
  int get hashCode => key.hashCode ^ judgeId.hashCode;
}

/// generated route for
/// [_i1.JudgesPage]
class JudgesRoute extends _i2.PageRouteInfo<void> {
  const JudgesRoute({List<_i2.PageRouteInfo>? children})
    : super(JudgesRoute.name, initialChildren: children);

  static const String name = 'JudgesRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      return const _i1.JudgesPage();
    },
  );
}

/// generated route for
/// [_i1.RingEditorPage]
class RingEditorRoute extends _i2.PageRouteInfo<RingEditorRouteArgs> {
  RingEditorRoute({
    _i3.Key? key,
    String? setupId,
    int? initialRingNumber,
    List<_i2.PageRouteInfo>? children,
  }) : super(
         RingEditorRoute.name,
         args: RingEditorRouteArgs(
           key: key,
           setupId: setupId,
           initialRingNumber: initialRingNumber,
         ),
         initialChildren: children,
       );

  static const String name = 'RingEditorRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RingEditorRouteArgs>(
        orElse: () => const RingEditorRouteArgs(),
      );
      return _i1.RingEditorPage(
        key: args.key,
        setupId: args.setupId,
        initialRingNumber: args.initialRingNumber,
      );
    },
  );
}

class RingEditorRouteArgs {
  const RingEditorRouteArgs({this.key, this.setupId, this.initialRingNumber});

  final _i3.Key? key;

  final String? setupId;

  final int? initialRingNumber;

  @override
  String toString() {
    return 'RingEditorRouteArgs{key: $key, setupId: $setupId, initialRingNumber: $initialRingNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RingEditorRouteArgs) return false;
    return key == other.key &&
        setupId == other.setupId &&
        initialRingNumber == other.initialRingNumber;
  }

  @override
  int get hashCode =>
      key.hashCode ^ setupId.hashCode ^ initialRingNumber.hashCode;
}

/// generated route for
/// [_i1.RingSetupPage]
class RingSetupRoute extends _i2.PageRouteInfo<void> {
  const RingSetupRoute({List<_i2.PageRouteInfo>? children})
    : super(RingSetupRoute.name, initialChildren: children);

  static const String name = 'RingSetupRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      return const _i1.RingSetupPage();
    },
  );
}
