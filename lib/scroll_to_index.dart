
import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_index/provider/tabProvider.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ScrollToIndexConfig {
  static AutoScrollController autoScrollController;

  static void Function(int index) onChanged;

  static scrollTo(index) {
    autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);

    onChanged?.call(index);
  }
}

class ScrollToIndex extends StatefulWidget {
  final int numberOfItems;
  final scrollableTabsCallBack;
  final Axis scrollDirection;
  ScrollToIndex(
      {Key key,
        this.scrollDirection = Axis.horizontal,
        @required this.numberOfItems,
        @required this.scrollableTabsCallBack})
      : super(key: key);

  @override
  _ScrollToIndexState createState() => _ScrollToIndexState();
}

class _ScrollToIndexState extends State<ScrollToIndex> {

  @override
  void initState() {
    super.initState();

    ScrollToIndexConfig.onChanged = (int index) {
      // print(index);
      // currentIndex = index;
      // setState(() {});
      context.read<TabProvider>().onChange(index);
    };

    ScrollToIndexConfig.autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: widget.scrollDirection);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollToIndexConfig.autoScrollController,
      itemCount: widget.numberOfItems,
      scrollDirection: widget.scrollDirection,
      itemBuilder: (BuildContext context, int index) {
        return _item(context, index);
      },
    );
  }

  Widget _item(BuildContext context, int index) {
    int currentIndex = context.watch<TabProvider>().currentIndex;
    return _wrapScrollTag(
      index: index,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            border: Border.all(
                width: 0.5,
                color: currentIndex == index ? Colors.red : Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color(0xfff5f5f5),
          ),
          child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                    fontSize: 18,
                    color: currentIndex == index ? Colors.red : Colors.black),
              )),
        ),
        onTap: () {
            context.read<TabProvider>().onChange(index);
            ScrollToIndexConfig.scrollTo(index);
          widget.scrollableTabsCallBack(index);
        },
      ),
    );
  }

  Widget _wrapScrollTag({@required int index, @required Widget child}) =>
      AutoScrollTag(
        key: ValueKey(index),
        controller: ScrollToIndexConfig.autoScrollController,
        index: index,
        child: child,
      );
}
