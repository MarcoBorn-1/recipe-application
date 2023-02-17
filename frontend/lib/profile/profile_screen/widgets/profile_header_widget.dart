import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader(
      {this.onSettingsTap,
      this.onLogoutTap,
      required this.username,
      required this.imageURL,
      required this.showIcons,
      super.key});
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;
  final String username;
  final String imageURL;
  final bool showIcons;

  @override
  State<StatefulWidget> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  Widget _settings() {
    if (widget.showIcons) {
      return GestureDetector(
        onTap: widget.onSettingsTap,
        child: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Icon(
            Icons.settings,
            color: Colors.white,
            size: 30,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _logout() {
    if (widget.showIcons) {
      return GestureDetector(
          onTap: widget.onLogoutTap,
          child: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(Icons.logout, color: Colors.white, size: 30),
          ));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 48, 47, 47),
              //borderRadius: BorderRadius.circular(10),
              border:
                  Border(bottom: BorderSide(width: 0.5, color: Colors.white))),
          width: double.infinity,
          height: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: _settings()),
              Expanded(
                flex: 6,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  CircleAvatar(
                      radius: 48,
                      backgroundImage: (widget.imageURL == "")
                          ? Image.asset("assets/images/profile_picture.jpg")
                              .image
                          : Image.network(
                              widget.imageURL,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                return const CircularProgressIndicator(
                                    color: Colors.white);
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    "assets/images/profile_picture.jpg");
                              },
                            ).image),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.username,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  )
                ]),
              ),
              Expanded(flex: 1, child: _logout()),
            ],
          )),
    );
  }
}
