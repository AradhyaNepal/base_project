
import 'package:flutter/material.dart';

import 'generic_state.dart';

class GenericStateWidget<T> extends StatelessWidget {
  final Widget Function(SuccessState<T>) onSuccess;
  final Widget Function(ErrorState<T>)? onError;
  final Widget Function()? loadingShimmer;
  final Future<void> Function() onErrorReload;
  final Future<void> Function()? onRefresh;
  final GenericState<T> state;

  const GenericStateWidget({
    super.key,
    required this.state,
    required this.onSuccess,
    required this.onErrorReload,
    this.loadingShimmer,
    this.onRefresh,
    this.onError,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final textTheme = Theme.of(context).textTheme;
    final state=this.state;
    Widget outputChild = switch (state) {
      SuccessState<T>() => onSuccess(state),
      ErrorState<T>() => onError?.call(state) ??
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.error.toString(),
              ),
              Center(
                child: TextButton(
                  onPressed: onErrorReload,
                  child: Text(
                    "Reload",
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
      _ => loadingShimmer?.call() ??
          const Center(
            child: CircularProgressIndicator(),
          ),
    };
    if (onRefresh != null) {
      return RefreshIndicator(
        child: outputChild,
        onRefresh: ()async{
          await onRefresh?.call();
        },
      );
    } else {
      return outputChild;
    }
  }
}
