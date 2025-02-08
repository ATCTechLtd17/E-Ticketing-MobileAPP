import 'package:flutter/material.dart';

class OverlayContainer extends StatefulWidget {
  final Widget child;
  final Widget overlayContent;

  final bool showOnFocus;

  final bool showOnTap;

  const OverlayContainer({
    super.key,
    required this.child,
    required this.overlayContent,
    this.showOnFocus = true,
    this.showOnTap = true,
  });

  @override
  OverlayContainerState createState() => OverlayContainerState();
}

class OverlayContainerState extends State<OverlayContainer> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _childKey = GlobalKey();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (widget.showOnFocus) {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    }
  }

  void _showOverlay() {
    // Prevent duplicate overlays.
    if (_overlayEntry != null) return;

    final renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Create an overlay entry that includes a full-screen barrier
    // and the overlay content positioned below the widget.
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Full screen transparent barrier to capture outside taps.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _removeOverlay();
                  _focusNode.unfocus();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // The overlay content positioned relative to the child widget.
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              width: size.width,
              child: Material(
                elevation: 8,
                child: widget.overlayContent,
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.showOnTap) {
          if (!_focusNode.hasFocus) {
            FocusScope.of(context).requestFocus(_focusNode);
          } else {
            _removeOverlay();
            _focusNode.unfocus();
          }
        }
      },
      child: Focus(
        focusNode: _focusNode,
        child: Container(
          key: _childKey,
          child: widget.child,
        ),
      ),
    );
  }
}
