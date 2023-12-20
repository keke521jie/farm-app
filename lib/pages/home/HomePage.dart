import "package:app/base/kernel/Logger.dart";
import "package:app/uikit/clip/ClipView.dart";
import "package:app/uikit/getIt.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";

import "HomePageBloc.dart";

class HomePage extends HookWidget with WidgetsBindingObserver {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var homeBloc = getIt<HomePageBloc>(param1: context);
    useEffect(() {
      homeBloc.initPlatformState(); // 初始化sdk监听后续操作
      homeBloc.initGetuiSdk(); // 初始化sdk
      homeBloc.getClientId(); //调用获取cid
      return null;
    }, []);
    logger.i("HomePage.build");
    return BlocProvider(
      create: (_) => homeBloc,
      child: BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
        var homeBloc = context.read<HomePageBloc>();

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [ClipView(uri: Uri.parse("https://farm.hswl007.com/clip/"))]),
        );
      }),
    );
  }
}
