import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:voola/shared.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'BottomSheet_only.dart';

const Duration _bottomSheetDuration = Duration(milliseconds: 400);
const Radius _default_bar_top_radius = Radius.circular(15);

const Radius _kDefaultTopRadius = Radius.circular(12);
const double _kPreviousPageVisibleOffset = 10;
typedef WidgetWithChildBuilder = Widget Function(
    BuildContext context, Animation<double> animation, Widget child);

class BarBottomSheet extends StatelessWidget {
  final Widget child;
  final Widget? control;
  final Clip? clipBehavior;
  final double? elevation;
  final ShapeBorder? shape;

  const BarBottomSheet({
    Key? key,
    required this.child,
    this.control,
    this.clipBehavior,
    this.shape,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            SafeArea(
              bottom: false,
              child: control ??
                  Container(
                    height: 6,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                  ),
            ),
            SizedBox(height: 8),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Material(
                shape: shape ??
                    RoundedRectangleBorder(
                      side: BorderSide(),
                      borderRadius: BorderRadius.only(
                          topLeft: _default_bar_top_radius,
                          topRight: _default_bar_top_radius),
                    ),
                clipBehavior: clipBehavior ?? Clip.hardEdge,
                elevation: elevation ?? 2,
                child: SizedBox(
                  width: double.infinity,
                  child: MediaQuery.removePadding(
                      context: context, removeTop: true, child: child),
                ),
              ),
            ),
          ]),
    );
  }
}

Future<T?> showCupertinoModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  double? closeProgressThreshold,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool expand = false,
  AnimationController? secondAnimation,
  Curve? animationCurve,
  Curve? previousRouteAnimationCurve,
  bool useRootNavigator = false,
  bool bounce = true,
  bool? isDismissible,
  bool enableDrag = true,
  Radius topRadius = _kDefaultTopRadius,
  Duration? duration,
  RouteSettings? settings,
  Color? transitionBackgroundColor,
  ScrollController? scrollController,
}) async {
  assert(debugCheckHasMediaQuery(context));

  final result =
      await Navigator.of(context, rootNavigator: useRootNavigator).push(
    CupertinoModalBottomSheetRoute<T>(
        builder: builder,
        containerBuilder: (context, _, child) => _CupertinoBottomSheetContainer(
              child: child,
              backgroundColor: backgroundColor,
              topRadius: topRadius,
            ),
        secondAnimationController: secondAnimation,
        expanded: expand,
        closeProgressThreshold: closeProgressThreshold,
        bounce: bounce,
        isDismissible: isDismissible ?? expand == false ? true : false,
        modalBarrierColor: barrierColor ?? Colors.black12,
        enableDrag: enableDrag,
        topRadius: topRadius,
        animationCurve: animationCurve,
        previousRouteAnimationCurve: previousRouteAnimationCurve,
        duration: duration,
        scrollController: scrollController,
        transitionBackgroundColor: transitionBackgroundColor ?? Colors.black),
  );
  return result;
}

class _CupertinoBottomSheetContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Radius topRadius;

  const _CupertinoBottomSheetContainer({
    Key? key,
    required this.child,
    this.backgroundColor,
    required this.topRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topSafeAreaPadding = MediaQuery.of(context).padding.top;
    final topPadding = _kPreviousPageVisibleOffset + topSafeAreaPadding;

    final _backgroundColor =
        backgroundColor ?? CupertinoTheme.of(context).scaffoldBackgroundColor;
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: topRadius),
        child: Container(
          decoration: BoxDecoration(color: _backgroundColor),
          width: double.infinity,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true, //Remove top Safe Area
            child: child,
          ),
        ),
      ),
    );
  }
}

class CupertinoModalBottomSheetRoute<T> extends PageRoute<T> {
  final double? closeProgressThreshold;
  final WidgetWithChildBuilder? containerBuilder;
  final WidgetBuilder builder;
  final bool expanded;
  final bool bounce;
  final Color? modalBarrierColor;
  final bool isDismissible;
  final bool enableDrag;
  final ScrollController? scrollController;

  final Duration? duration;

  final AnimationController? secondAnimationController;
  final Curve? animationCurve;
  final Radius topRadius;

  final Curve? previousRouteAnimationCurve;

  // Background color behind all routes
  // Black by default
  final Color? transitionBackgroundColor;

  CupertinoModalBottomSheetRoute({
    required this.builder,
    this.containerBuilder,
    this.closeProgressThreshold,
    this.secondAnimationController,
    this.animationCurve,
    this.modalBarrierColor,
    this.bounce = true,
    this.isDismissible = true,
    this.enableDrag = true,
    required this.expanded,
    this.duration,
    this.scrollController,
    this.transitionBackgroundColor,
    this.topRadius = _kDefaultTopRadius,
    this.previousRouteAnimationCurve,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final paddingTop = MediaQuery.of(context).padding.top;
    final distanceWithScale = (paddingTop + _kPreviousPageVisibleOffset) * 0.9;
    final offsetY = secondaryAnimation.value * (paddingTop - distanceWithScale);
    final scale = 1 - secondaryAnimation.value / 10;
    return AnimatedBuilder(
      builder: (context, child) => Transform.translate(
        offset: Offset(0, offsetY),
        child: Transform.scale(
          scale: scale,
          child: child,
          alignment: Alignment.topCenter,
        ),
      ),
      child: child,
      animation: secondaryAnimation,
    );
  }

  Widget getPreviousRouteTransition(BuildContext context,
      Animation<double> secondaryAnimation, Widget child) {
    return _CupertinoModalTransition(
      secondaryAnimation: secondaryAnimation,
      body: child,
      animationCurve: previousRouteAnimationCurve,
      topRadius: topRadius,
      backgroundColor: transitionBackgroundColor ?? Colors.black,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      // removeTop: true,
      child: _ModalBottomSheet<T>(
        closeProgressThreshold: closeProgressThreshold,
        route: this,
        secondAnimationController: secondAnimationController,
        expanded: expanded,
        bounce: bounce,
        enableDrag: enableDrag,
        animationCurve: animationCurve,
      ),
    );
    return bottomSheet;
  }

  @override
  Duration get transitionDuration => duration ?? _bottomSheetDuration;

  @override
  bool get barrierDismissible => isDismissible;
  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black.withOpacity(0.35);

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = AnimationController(
      duration: duration ?? _bottomSheetDuration,
      debugLabel: 'BottomSheet',
      vsync: navigator!.overlay!,
    );

    return _animationController!;
  }

  bool get _hasScopedWillPopCallback => hasScopedWillPopCallback;
}

class _CupertinoModalTransition extends StatelessWidget {
  final Animation<double> secondaryAnimation;
  final Radius topRadius;
  final Curve? animationCurve;
  final Color backgroundColor;

  final Widget body;

  const _CupertinoModalTransition({
    Key? key,
    required this.secondaryAnimation,
    required this.body,
    required this.topRadius,
    this.backgroundColor = Colors.black,
    this.animationCurve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var startRoundCorner = 0.0;
    final paddingTop = MediaQuery.of(context).padding.top;
    if (Theme.of(context).platform == TargetPlatform.iOS && paddingTop > 20) {
      startRoundCorner = 38.5;
      //https://kylebashour.com/posts/finding-the-real-iphone-x-corner-radius
    }

    final curvedAnimation = CurvedAnimation(
      parent: secondaryAnimation,
      curve: animationCurve ?? Curves.easeOut,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AnimatedBuilder(
        animation: curvedAnimation,
        child: body,
        builder: (context, child) {
          final progress = curvedAnimation.value;
          final yOffset = progress * paddingTop;
          final scale = 1 - progress / 10;
          final radius = progress == 0
              ? 0.0
              : (1 - progress) * startRoundCorner + progress * topRadius.x;
          return Stack(
            children: <Widget>[
              Container(color: backgroundColor),
              Transform.translate(
                offset: Offset(0, yOffset),
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: child),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({
    Key? key,
    this.closeProgressThreshold,
    required this.route,
    this.secondAnimationController,
    this.bounce = false,
    this.expanded = false,
    this.enableDrag = true,
    this.animationCurve,
  }) : super(key: key);

  final double? closeProgressThreshold;
  final CupertinoModalBottomSheetRoute<T> route;
  final bool expanded;
  final bool bounce;
  final bool enableDrag;
  final AnimationController? secondAnimationController;
  final Curve? animationCurve;

  @override
  _ModalBottomSheetState<T> createState() => _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  String _getRouteLabel() {
    final platform = Theme.of(context).platform; //?? defaultTargetPlatform;
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return '';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        if (Localizations.of(context, MaterialLocalizations) != null) {
          return MaterialLocalizations.of(context).dialogLabel;
        } else {
          return DefaultMaterialLocalizations().dialogLabel;
        }
    }
  }

  ScrollController? _scrollController;

  @override
  void initState() {
    widget.route.animation?.addListener(updateController);
    super.initState();
  }

  @override
  void dispose() {
    widget.route.animation?.removeListener(updateController);
    _scrollController?.dispose();
    super.dispose();
  }

  void updateController() {
    final animation = widget.route.animation;
    if (animation != null) {
      widget.secondAnimationController?.value = animation.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(widget.route._animationController != null);
    final scrollController = PrimaryScrollController.of(context) ??
        (_scrollController ??= ScrollController());
    return ModalScrollController(
      controller: scrollController,
      child: Builder(
        builder: (context) => AnimatedBuilder(
          animation: widget.route._animationController!,
          builder: (BuildContext context, final Widget? child) {
            assert(child != null);
            // Disable the initial animation when accessible navigation is on so
            // that the semantics are added to the tree at the correct time.
            return Semantics(
              scopesRoute: true,
              namesRoute: true,
              label: _getRouteLabel(),
              explicitChildNodes: true,
              child: ModalBottomSheet(
                closeProgressThreshold: widget.closeProgressThreshold,
                expanded: widget.route.expanded,
                containerBuilder: widget.route.containerBuilder,
                animationController: widget.route._animationController!,
                shouldClose: widget.route._hasScopedWillPopCallback
                    ? () async {
                        final willPop = await widget.route.willPop();
                        return willPop != RoutePopDisposition.doNotPop;
                      }
                    : null,
                onClosing: () {
                  if (widget.route.isCurrent) {
                    Navigator.of(context).pop();
                  }
                },
                child: child!,
                enableDrag: widget.enableDrag,
                bounce: widget.bounce,
                scrollController: scrollController,
                animationCurve: widget.animationCurve,
              ),
            );
          },
          child: widget.route.builder(context),
        ),
      ),
    );
  }
}

class ModalScrollController extends InheritedWidget {
  /// Creates a widget that associates a [ScrollController] with a subtree.
  ModalScrollController({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(
          key: key,
          child: PrimaryScrollController(
            controller: controller,
            child: child,
          ),
        );

  /// The [ScrollController] associated with the subtree.
  ///
  /// See also:
  ///
  ///  * [ScrollView.controller], which discusses the purpose of specifying a
  ///    scroll controller.
  final ScrollController controller;

  /// Returns the [ScrollController] most closely associated with the given
  /// context.
  ///
  /// Returns null if there is no [ScrollController] associated with the given
  /// context.
  static ScrollController? of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<ModalScrollController>();
    return result?.controller;
  }

  @override
  bool updateShouldNotify(ModalScrollController oldWidget) =>
      controller != oldWidget.controller;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ScrollController>(
        'controller', controller,
        ifNull: 'no controller', showName: false));
  }
}
