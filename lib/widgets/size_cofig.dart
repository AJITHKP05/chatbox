import 'package:flutter/widgets.dart'
    show BuildContext, MediaQuery, SizedBox, SliverToBoxAdapter;

extension SizeConfig on BuildContext {
  double get blockSizeHorizontal {
    final _mediaQueryData = MediaQuery.of(this);
    return (_mediaQueryData.size.width / 100);
  }

  double get blockSizeVertical {
    final _mediaQueryData = MediaQuery.of(this);
    return (_mediaQueryData.size.height / 100);
  }

  double get safeBlockHorizontal {
    final _mq = MediaQuery.of(this);
    final _safePadding = _mq.padding.left + _mq.padding.right;
    return ((_mq.size.height - _safePadding) / 100);
  }

  double get safeBlockVertical {
    final _mq = MediaQuery.of(this);
    final _safePadding = _mq.padding.top + _mq.padding.bottom;
    return ((_mq.size.width - _safePadding) / 100);
  }

  SizedBox get columnSpacer => SizedBox(height: blockSizeVertical * 2);
  SizedBox get rowSpacer => SizedBox(width: blockSizeHorizontal * 2);

  SliverToBoxAdapter get sliverSpacer =>
      SliverToBoxAdapter(child: SizedBox(height: blockSizeVertical * 2));

  double get safePaddingTop => MediaQuery.of(this).padding.top;
}
