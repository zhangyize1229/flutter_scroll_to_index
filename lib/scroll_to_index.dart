
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ScrollToIndexConfig {
  static AutoScrollController autoScrollController;

  static scrollTo(index) {
    autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
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
  int currentIndex =0;


  @override
  void initState() {
    super.initState();
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
          setState(() {
            currentIndex=index;
            ScrollToIndexConfig.scrollTo(index);
          });
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
