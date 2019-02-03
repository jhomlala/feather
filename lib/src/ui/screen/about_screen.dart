import 'package:feather/src/resources/config/application_colors.dart';
import 'package:feather/src/resources/config/assets.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
                key: Key("weather_main_screen_container"),
                decoration: BoxDecoration(
                    gradient: WidgetHelper.buildGradient(
                        ApplicationColors.nightStartColor,
                        ApplicationColors.nightEndColor)),
                child: _getAboutContainer(context)),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent, //No more green
                elevation: 0.0, //Shadow gone
              ),
            ),
          ],
        ));
  }

  Widget _getAboutContainer(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        child: Image.asset(Assets.iconLogo,
            key: Key("about_screen_logo"), width: 250, height: 250),
        onTap: () => _onLogoClicked(),
      ),
      Text("feather",
          key: Key("about_screen_app_name"),
          style: Theme.of(context).textTheme.title),
      FutureBuilder<String>(
        future: _getVersionAndBuildNumber(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data,
                key: Key("about_screen_app_version_and_build"),
                style: Theme.of(context).textTheme.subtitle);
          } else {
            return Container(key: Key("about_screen_app_version_and_build"));
          }
        },
      ),
      WidgetHelper.buildPadding(top: 20),
      Text("Contributors:", key: Key("about_screen_contributors"), style: Theme.of(context).textTheme.subtitle),
      WidgetHelper.buildPadding(top: 10),
      Text("Jakub Homlala (jhomlala)"),
      WidgetHelper.buildPadding(top: 2),
      Text("Jake Gough (SnakeyHips)"),
      WidgetHelper.buildPadding(top: 20),
      Text("Credits:",key: Key("about_screen_credits"), style: Theme.of(context).textTheme.subtitle),
      WidgetHelper.buildPadding(top: 10),
      Text("Weather data: OpenWeatherAPI"),
      WidgetHelper.buildPadding(top: 2),
      Text("Icons: Icons8, Freepik/Flaticon")
    ]));
  }

  Future<String> _getVersionAndBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version} (${packageInfo.buildNumber})";
  }

  _onLogoClicked() async {
    const url = 'https://github.com/jhomlala/feather';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
