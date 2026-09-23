import 'package:flutter/widgets.dart';

/// Breakpoint tunggal: >= 600 shortestSide = tablet.
bool isTablet(BuildContext context) =>
    MediaQuery.sizeOf(context).shortestSide >= tabletBreakpoint;

const double tabletBreakpoint = 600;
