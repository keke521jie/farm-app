import "package:app/base/kernel/Logger.dart";
import "package:app/config/MsgHandler.dart";
import "package:app/uikit/clip/ClipView.dart";
import "package:app/uikit/clip/ClipMsgHandler.dart";
import "package:app/uikit/getIt.dart";
import "package:app/uikit/navigatorKey.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";

import "HomePageBloc.dart";

class HomePage extends HookWidget with WidgetsBindingObserver {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i("HomePage.build");

    var msgHandler = getIt<MsgHandler>();
    var clipMsgHandler = useMemoized(() => ClipMsgHandler());

    var homeBloc = useMemoized(() {
      return getIt<HomePageBloc>(param1: context);
    }, []);

    useEffect(() {
      return null;
    }, []);

    return BlocProvider(
      create: (_) => homeBloc,
      child: BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
        var homeBloc = context.read<HomePageBloc>();

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            ClipView(
              key: const ValueKey("ClipView"),
              uri: Uri.parse("http://192.168.3.44:10086/"),
              msgHandlers: [msgHandler, clipMsgHandler],
              navigatorKey: navigatorKey,
            ),
          ]),
        );
      }),
    );
  }
}
