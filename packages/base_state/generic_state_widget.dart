import 'package:flutter/material.dart';

import 'generic_state.dart';

class GenericStateWidget<T> extends StatelessWidget {
  final Widget Function(SuccessState<T>) onSuccess;
  final Widget Function(ErrorState<T>)? onError;
  final Widget Function()? loadingShimmer;
  final Future<void> Function() onErrorReload;
  final Future<void> Function()? onRefresh;
  final GenericState<T> state;
  final bool Function(SuccessState<T>)? isEmptyCheck;
  ///[isEmptyCheck] value must be true to display this widget.
  ///If widget not passed "No result" text will be shown.
  final Widget Function(SuccessState<T>)? onEmpty;

  const GenericStateWidget({
    super.key,
    required this.state,
    required this.onSuccess,
    required this.onErrorReload,
    this.loadingShimmer,
    this.onRefresh,
    this.onError,
    this.isEmptyCheck,
    this.onEmpty,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final textTheme = Theme.of(context).textTheme;
    final state=this.state;
    Widget outputChild = switch (state) {
      SuccessState<T>()=>_onSuccessWidget(state,textTheme),
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
                    "Reload",//Todo: Add Locale
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

  Widget _onSuccessWidget(SuccessState<T> state,TextTheme textTheme,){
    if(isEmptyCheck?.call(state)==true){
      return onEmpty?.call(state)??Text(
        "No Result",//Todo: Add locale
        style: textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }else{
      return onSuccess(state);
    }
  }
}


class GenericStatePaginationWidget<T> extends StatefulWidget {
  final Widget Function(SuccessState<T>) onSuccess;
  final Widget Function(ErrorState<T>)? onError;
  final VoidCallback fetchNextPage;
  final ScrollController scrollController;
  final Widget Function()? loadingShimmer;
  final Future<void> Function() onErrorReload;
  final Future<void> Function()? onRefresh;
  final GenericState<T> state;
  const GenericStatePaginationWidget({
    super.key,
    required this.state,
    required this.onSuccess,
    required this.onErrorReload,
    required this.scrollController,
    required this.fetchNextPage,
    this.loadingShimmer,
    this.onRefresh,
    this.onError,
  });

  @override
  State<GenericStatePaginationWidget<T>> createState() => _GenericStatePaginationWidgetState<T>();
}

class _GenericStatePaginationWidgetState<T> extends State<GenericStatePaginationWidget<T>> {

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(scrollListener);
  }

  void scrollListener(){
    if(!context.mounted)return;
    if(widget.state.canDoPagination(widget.scrollController)){
      widget.fetchNextPage();
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(scrollListener);
    super.dispose();
  }
}
