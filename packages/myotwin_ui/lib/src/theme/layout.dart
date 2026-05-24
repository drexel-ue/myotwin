// ignore_for_file: public_member_api_docs (just to avoid having to write docs for every single constant in this file.)

import 'package:flutter/material.dart';

const emptyWidget = SizedBox.shrink();
const emptyWidgetWide = SizedBox(width: double.infinity);

// Spacings

const spacer = Spacer();
const spacing2 = 2.0;
const spacing4 = 4.0;
const spacing8 = 8.0;
const spacing10 = 10.0;
const spacing12 = 12.0;
const spacing16 = 16.0;
const spacing20 = 20.0;
const spacing24 = 24.0;
const spacing32 = 32.0;
const spacing40 = 40.0;
const spacing48 = 48.0;
const spacing64 = 64.0;
const spacing72 = 72.0;
const spacing96 = 96.0;
const spacing120 = 120.0;
const spacing336 = 336.0;

// Margins

const horizontalMargin2 = SizedBox(width: 2.0);
const horizontalMargin4 = SizedBox(width: 4.0);
const horizontalMargin6 = SizedBox(width: 6.0);
const horizontalMargin8 = SizedBox(width: 8.0);
const horizontalMargin12 = SizedBox(width: 12.0);
const horizontalMargin16 = SizedBox(width: 16.0);
const horizontalMargin24 = SizedBox(width: 24.0);
const horizontalMargin32 = SizedBox(width: 32.0);
const horizontalMargin48 = SizedBox(width: 48.0);
const horizontalMargin64 = SizedBox(width: 64.0);
const horizontalMargin96 = SizedBox(width: 96.0);

const verticalMargin2 = SizedBox(height: 2.0);
const verticalMargin4 = SizedBox(height: 4.0);
const verticalMargin8 = SizedBox(height: 8.0);
const verticalMargin10 = SizedBox(height: 10.0);
const verticalMargin12 = SizedBox(height: 12.0);
const verticalMargin16 = SizedBox(height: 16.0);
const verticalMargin18 = SizedBox(height: 18.0);
const verticalMargin24 = SizedBox(height: 24.0);
const verticalMargin30 = SizedBox(height: 30.0);
const verticalMargin32 = SizedBox(height: 32.0);
const verticalMargin48 = SizedBox(height: 48.0);
const verticalMargin64 = SizedBox(height: 64.0);
const verticalMargin96 = SizedBox(height: 96.0);

const sliverVerticalMargin2 = SliverToBoxAdapter(child: SizedBox(height: 2.0));
const sliverVerticalMargin4 = SliverToBoxAdapter(child: SizedBox(height: 4.0));
const sliverVerticalMargin8 = SliverToBoxAdapter(child: SizedBox(height: 8.0));
const sliverVerticalMargin12 = SliverToBoxAdapter(child: SizedBox(height: 12.0));
const sliverVerticalMargin16 = SliverToBoxAdapter(child: SizedBox(height: 16.0));
const sliverVerticalMargin24 = SliverToBoxAdapter(child: SizedBox(height: 24.0));
const sliverVerticalMargin32 = SliverToBoxAdapter(child: SizedBox(height: 32.0));
const sliverVerticalMargin48 = SliverToBoxAdapter(child: SizedBox(height: 48.0));
const sliverVerticalMargin64 = SliverToBoxAdapter(child: SizedBox(height: 64.0));
const sliverVerticalMargin96 = SliverToBoxAdapter(child: SizedBox(height: 96.0));

// Paddings

const EdgeInsetsDirectional emptyPadding = .zero;

const horizontalPadding2 = EdgeInsetsDirectional.symmetric(horizontal: 2.0);
const horizontalPadding4 = EdgeInsetsDirectional.symmetric(horizontal: 4.0);
const horizontalPadding6 = EdgeInsetsDirectional.symmetric(horizontal: 6.0);
const horizontalPadding8 = EdgeInsetsDirectional.symmetric(horizontal: 8.0);
const horizontalPadding10 = EdgeInsetsDirectional.symmetric(horizontal: 10.0);
const horizontalPadding12 = EdgeInsetsDirectional.symmetric(horizontal: 12.0);
const horizontalPadding16 = EdgeInsetsDirectional.symmetric(horizontal: 16.0);
const horizontalPadding24 = EdgeInsetsDirectional.symmetric(horizontal: 24.0);
const horizontalPadding32 = EdgeInsetsDirectional.symmetric(horizontal: 32.0);
const horizontalPadding48 = EdgeInsetsDirectional.symmetric(horizontal: 48.0);
const horizontalPadding64 = EdgeInsetsDirectional.symmetric(horizontal: 64.0);
const horizontalPadding88 = EdgeInsetsDirectional.symmetric(horizontal: 88.5);
const horizontalPadding128 = EdgeInsetsDirectional.symmetric(horizontal: 128.0);

const verticalPadding2 = EdgeInsetsDirectional.symmetric(vertical: 2.0);
const verticalPadding4 = EdgeInsetsDirectional.symmetric(vertical: 4.0);
const verticalPadding6 = EdgeInsetsDirectional.symmetric(vertical: 6.0);
const verticalPadding8 = EdgeInsetsDirectional.symmetric(vertical: 8.0);
const verticalPadding10 = EdgeInsetsDirectional.symmetric(vertical: 10.0);
const verticalPadding12 = EdgeInsetsDirectional.symmetric(vertical: 12.0);
const verticalPadding14 = EdgeInsetsDirectional.symmetric(vertical: 14.0);
const verticalPadding16 = EdgeInsetsDirectional.symmetric(vertical: 16.0);
const verticalPadding24 = EdgeInsetsDirectional.symmetric(vertical: 24.0);
const verticalPadding32 = EdgeInsetsDirectional.symmetric(vertical: 32.0);
const verticalPadding48 = EdgeInsetsDirectional.symmetric(vertical: 48.0);
const verticalPadding64 = EdgeInsetsDirectional.symmetric(vertical: 64.0);

const allPadding2 = EdgeInsetsDirectional.all(2.0);
const allPadding4 = EdgeInsetsDirectional.all(4.0);
const allPadding6 = EdgeInsetsDirectional.all(6.0);
const allPadding8 = EdgeInsetsDirectional.all(8.0);
const allPadding12 = EdgeInsetsDirectional.all(12.0);
const allPadding14 = EdgeInsetsDirectional.all(14.0);
const allPadding16 = EdgeInsetsDirectional.all(16.0);
const allPadding24 = EdgeInsetsDirectional.all(24.0);
const allPadding32 = EdgeInsetsDirectional.all(32.0);
const allPadding44 = EdgeInsetsDirectional.all(44.0);
const allPadding48 = EdgeInsetsDirectional.all(48.0);
const allPadding64 = EdgeInsetsDirectional.all(64.0);

const topPadding1 = EdgeInsetsDirectional.only(top: 1.0);
const topPadding2 = EdgeInsetsDirectional.only(top: 2.0);
const topPadding4 = EdgeInsetsDirectional.only(top: 4.0);
const topPadding6 = EdgeInsetsDirectional.only(top: 6.0);
const topPadding8 = EdgeInsetsDirectional.only(top: 8.0);
const topPadding12 = EdgeInsetsDirectional.only(top: 12.0);
const topPadding16 = EdgeInsetsDirectional.only(top: 16.0);
const topPadding20 = EdgeInsetsDirectional.only(top: 20.0);
const topPadding24 = EdgeInsetsDirectional.only(top: 24.0);
const topPadding32 = EdgeInsetsDirectional.only(top: 32.0);
const topPadding48 = EdgeInsetsDirectional.only(top: 48.0);
const topPadding64 = EdgeInsetsDirectional.only(top: 64.0);
const topPadding128 = EdgeInsetsDirectional.only(top: 128.0);

const bottomPadding1 = EdgeInsetsDirectional.only(bottom: 1.0);
const bottomPadding2 = EdgeInsetsDirectional.only(bottom: 2.0);
const bottomPadding4 = EdgeInsetsDirectional.only(bottom: 4.0);
const bottomPadding6 = EdgeInsetsDirectional.only(bottom: 6.0);
const bottomPadding8 = EdgeInsetsDirectional.only(bottom: 8.0);
const bottomPadding12 = EdgeInsetsDirectional.only(bottom: 12.0);
const bottomPadding14 = EdgeInsetsDirectional.only(bottom: 14.0);
const bottomPadding16 = EdgeInsetsDirectional.only(bottom: 16.0);
const bottomPadding24 = EdgeInsetsDirectional.only(bottom: 24.0);
const bottomPadding32 = EdgeInsetsDirectional.only(bottom: 32.0);
const bottomPadding48 = EdgeInsetsDirectional.only(bottom: 48.0);
const bottomPadding64 = EdgeInsetsDirectional.only(bottom: 64.0);

/// We should make use of `startPaddingN` instead of `leftPaddingN`
/// always target Directionality.
///
/// This applies to custom packages, and some widgets like Dialog, which takes an `EdgeInset`
/// instead of `EdgeInsetGeometry`, so use this approach for that:
///
/// example:
/// ```dart
///   Dialog(
///     insetPadding: (allPadding48 + allPadding24).resolve(Directionality.of(context)),
///     child: ...
/// ```
///
const EdgeInsetsDirectional leftPadding2 = startPadding2;
const EdgeInsetsDirectional leftPadding4 = startPadding4;
const EdgeInsetsDirectional leftPadding8 = startPadding8;
const EdgeInsetsDirectional leftPadding10 = startPadding10;
const EdgeInsetsDirectional leftPadding12 = startPadding12;
const EdgeInsetsDirectional leftPadding16 = startPadding16;
const EdgeInsetsDirectional leftPadding24 = startPadding24;
const EdgeInsetsDirectional leftPadding32 = startPadding32;
const EdgeInsetsDirectional leftPadding48 = startPadding48;
const EdgeInsetsDirectional leftPadding64 = startPadding64;

const EdgeInsetsDirectional rightPadding2 = endPadding2;
const EdgeInsetsDirectional rightPadding4 = endPadding4;
const EdgeInsetsDirectional rightPadding8 = endPadding8;
const EdgeInsetsDirectional rightPadding12 = endPadding12;
const EdgeInsetsDirectional rightPadding14 = endPadding14;
const EdgeInsetsDirectional rightPadding16 = endPadding16;
const EdgeInsetsDirectional rightPadding24 = endPadding24;
const EdgeInsetsDirectional rightPadding32 = endPadding32;
const EdgeInsetsDirectional rightPadding48 = endPadding48;
const EdgeInsetsDirectional rightPadding64 = endPadding64;

const startPadding2 = EdgeInsetsDirectional.only(start: 2.0);
const startPadding4 = EdgeInsetsDirectional.only(start: 4.0);
const startPadding8 = EdgeInsetsDirectional.only(start: 8.0);
const startPadding10 = EdgeInsetsDirectional.only(start: 10.0);
const startPadding12 = EdgeInsetsDirectional.only(start: 12.0);
const startPadding16 = EdgeInsetsDirectional.only(start: 16.0);
const startPadding24 = EdgeInsetsDirectional.only(start: 24.0);
const startPadding32 = EdgeInsetsDirectional.only(start: 32.0);
const startPadding48 = EdgeInsetsDirectional.only(start: 48.0);
const startPadding64 = EdgeInsetsDirectional.only(start: 64.0);

const endPadding2 = EdgeInsetsDirectional.only(end: 2.0);
const endPadding4 = EdgeInsetsDirectional.only(end: 4.0);
const endPadding8 = EdgeInsetsDirectional.only(end: 8.0);
const endPadding12 = EdgeInsetsDirectional.only(end: 12.0);
const endPadding14 = EdgeInsetsDirectional.only(end: 14.0);
const endPadding16 = EdgeInsetsDirectional.only(end: 16.0);
const endPadding24 = EdgeInsetsDirectional.only(end: 24.0);
const endPadding32 = EdgeInsetsDirectional.only(end: 32.0);
const endPadding48 = EdgeInsetsDirectional.only(end: 48.0);
const endPadding64 = EdgeInsetsDirectional.only(end: 64.0);

// Circular Radius
const circularRadius2 = Radius.circular(2.0);
const circularRadius4 = Radius.circular(4.0);
const circularRadius6 = Radius.circular(6.0);
const circularRadius8 = Radius.circular(8.0);
const circularRadius12 = Radius.circular(12.0);
const circularRadius16 = Radius.circular(16.0);
const circularRadius24 = Radius.circular(24.0);
const circularRadius32 = Radius.circular(32.0);
const circularRadius48 = Radius.circular(48.0);
const circularRadius64 = Radius.circular(64.0);

// Borders
const borderRadius2 = BorderRadius.all(circularRadius2);
const borderRadius4 = BorderRadius.all(circularRadius4);
const borderRadius6 = BorderRadius.all(circularRadius6);
const borderRadius8 = BorderRadius.all(circularRadius8);
const borderRadius12 = BorderRadius.all(circularRadius12);
const borderRadius16 = BorderRadius.all(circularRadius16);
const borderRadius24 = BorderRadius.all(circularRadius24);
const borderRadius32 = BorderRadius.all(circularRadius32);
const borderRadius48 = BorderRadius.all(circularRadius48);
const borderRadius64 = BorderRadius.all(circularRadius64);

const topBorderRadius2 = BorderRadius.only(topLeft: circularRadius2, topRight: circularRadius2);
const topBorderRadius4 = BorderRadius.only(topLeft: circularRadius4, topRight: circularRadius4);
const topBorderRadius8 = BorderRadius.only(topLeft: circularRadius8, topRight: circularRadius8);
const topBorderRadius12 = BorderRadius.only(topLeft: circularRadius12, topRight: circularRadius12);
const topBorderRadius16 = BorderRadius.only(topLeft: circularRadius16, topRight: circularRadius16);
const topBorderRadius24 = BorderRadius.only(topLeft: circularRadius24, topRight: circularRadius24);
const topBorderRadius32 = BorderRadius.only(topLeft: circularRadius32, topRight: circularRadius32);
const topBorderRadius48 = BorderRadius.only(topLeft: circularRadius48, topRight: circularRadius48);
const topBorderRadius64 = BorderRadius.only(topLeft: circularRadius64, topRight: circularRadius64);

const bottomBorderRadius2 = BorderRadius.only(
  bottomLeft: circularRadius2,
  bottomRight: circularRadius2,
);
const bottomBorderRadius4 = BorderRadius.only(
  bottomLeft: circularRadius4,
  bottomRight: circularRadius4,
);
const bottomBorderRadius8 = BorderRadius.only(
  bottomLeft: circularRadius8,
  bottomRight: circularRadius8,
);
const bottomBorderRadius12 = BorderRadius.only(
  bottomLeft: circularRadius12,
  bottomRight: circularRadius12,
);
const bottomBorderRadius16 = BorderRadius.only(
  bottomLeft: circularRadius16,
  bottomRight: circularRadius16,
);
const bottomBorderRadius24 = BorderRadius.only(
  bottomLeft: circularRadius24,
  bottomRight: circularRadius24,
);
const bottomBorderRadius32 = BorderRadius.only(
  bottomLeft: circularRadius32,
  bottomRight: circularRadius32,
);
const bottomBorderRadius48 = BorderRadius.only(
  bottomLeft: circularRadius48,
  bottomRight: circularRadius48,
);
const bottomBorderRadius64 = BorderRadius.only(
  bottomLeft: circularRadius64,
  bottomRight: circularRadius64,
);

const leftBorderRadius2 = BorderRadius.only(
  topLeft: circularRadius2,
  bottomLeft: circularRadius2,
);
const leftBorderRadius4 = BorderRadius.only(
  topLeft: circularRadius4,
  bottomLeft: circularRadius4,
);
const leftBorderRadius8 = BorderRadius.only(
  topLeft: circularRadius8,
  bottomLeft: circularRadius8,
);
const leftBorderRadius12 = BorderRadius.only(
  topLeft: circularRadius12,
  bottomLeft: circularRadius12,
);
const leftBorderRadius16 = BorderRadius.only(
  topLeft: circularRadius16,
  bottomLeft: circularRadius16,
);
const leftBorderRadius24 = BorderRadius.only(
  topLeft: circularRadius24,
  bottomLeft: circularRadius24,
);
const leftBorderRadius32 = BorderRadius.only(
  topLeft: circularRadius32,
  bottomLeft: circularRadius32,
);
const leftBorderRadius48 = BorderRadius.only(
  topLeft: circularRadius48,
  bottomLeft: circularRadius48,
);
const leftBorderRadius64 = BorderRadius.only(
  topLeft: circularRadius64,
  bottomLeft: circularRadius64,
);

const rightBorderRadius2 = BorderRadius.only(
  topRight: circularRadius2,
  bottomRight: circularRadius2,
);
const rightBorderRadius4 = BorderRadius.only(
  topRight: circularRadius4,
  bottomRight: circularRadius4,
);
const rightBorderRadius8 = BorderRadius.only(
  topRight: circularRadius8,
  bottomRight: circularRadius8,
);
const rightBorderRadius12 = BorderRadius.only(
  topRight: circularRadius12,
  bottomRight: circularRadius12,
);
const rightBorderRadius16 = BorderRadius.only(
  topRight: circularRadius16,
  bottomRight: circularRadius16,
);
const rightBorderRadius24 = BorderRadius.only(
  topRight: circularRadius24,
  bottomRight: circularRadius24,
);
const rightBorderRadius32 = BorderRadius.only(
  topRight: circularRadius32,
  bottomRight: circularRadius32,
);
const rightBorderRadius48 = BorderRadius.only(
  topRight: circularRadius48,
  bottomRight: circularRadius48,
);
const rightBorderRadius64 = BorderRadius.only(
  topRight: circularRadius64,
  bottomRight: circularRadius64,
);
