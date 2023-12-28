

import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  final Widget? child;
  final bool loading;

  const LoadingIndicator({
    this.child,
    this.loading = true,
    super.key
    });

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Opacity(
          opacity: widget.loading? 0.3:1,
          child: widget.child,
        ),

        widget.loading? const CircularProgressIndicator.adaptive():Container()
      ]
    );
  }
}