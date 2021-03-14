import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/constatns/common_size.dart';
import 'package:instagram_two_record/constatns/screen_size.dart';
import 'package:instagram_two_record/models/user_model_state.dart';
import 'package:instagram_two_record/screens/profile_screen.dart';
import 'package:instagram_two_record/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatefulWidget {
  final Function() onMenuChanged;

  const ProfileBody({Key key, this.onMenuChanged}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesPageMargin = 0;
  double _rightImagesPageMargin = size.width;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    //해당 스테이트가 새로 생성될때 실행된다
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: duration, //
    );
    super.initState();
  }

  @override
  void dispose() {
    //해당 스테이트가 버려질때 실행된다
    _iconAnimationController.dispose(); //이걸 해줘야 메모리 leak을 놓치지 않고 퍼포먼스 확보
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _appbar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(common_gap),
                          child: RoundedAvatar(
                            size: 80,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: common_gap),
                            child: Table(
                              children: [
                                TableRow(children: [
                                  _valueText('123123'),
                                  _valueText('234567'),
                                  _valueText('32434323'),
                                ]),
                                TableRow(children: [
                                  _labelText('Post'),
                                  _labelText('Followers'),
                                  _labelText('Following'),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    _username(context),
                    _userBio(),
                    _editProfileBtn(),
                    _tabButtons(),
                    _selectedIndicator(),
                  ]),
                ),
                _imagesPager(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _appbar() {
    return Row(
      children: [
        SizedBox(
          width: 44,
        ),
        Expanded(
            child: Text(
          'BjSky!!',
          textAlign: TextAlign.center,
        )),
        IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _iconAnimationController,
          ),
          onPressed: () {
            widget.onMenuChanged(); //내가 StatefulWiget 값을 접근하고 싶으면 widget.으로 접근
            _iconAnimationController.status == AnimationStatus.completed
                ? _iconAnimationController.reverse()
                : _iconAnimationController.forward();
          }, //onPressed가 지정이 안되어있으면 아이콘이 회색으로 된다.
        )
      ],
    );
  }

  Text _valueText(String value) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Text _labelText(String label) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
    );
  }

  SliverToBoxAdapter _imagesPager() {
    return SliverToBoxAdapter(
        child: Stack(
      children: [
        AnimatedContainer(
          duration: duration,
          transform: Matrix4.translationValues(_leftImagesPageMargin, 0, 0),
          //좌우만 이동시켜줄거니까 x값만 변화
          curve: Curves.fastOutSlowIn,
          child: _images(),
        ),
        AnimatedContainer(
          duration: duration,
          transform: Matrix4.translationValues(
              _rightImagesPageMargin, 0, 0), //좌우만 이동시켜줄거니까 x값만 변화
          curve: Curves.fastOutSlowIn,
          child: _images(),
        ),
      ],
    ));
  }

  GridView _images() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      childAspectRatio: 1,
      crossAxisCount: 3,
      children: List.generate(
          30,
          (index) => CachedNetworkImage(
                imageUrl: "https://picsum.photos/id/$index/100/100",
                fit: BoxFit.cover,
              )),
    );
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
      duration: duration,
      alignment: _selectedTab == SelectedTab.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        height: 3,
        width: size.width / 2,
        color: Colors.black87,
      ),
      curve: Curves.easeInOut,
    );
  }

  Row _tabButtons() {
    return Row(
      children: [
        Expanded(
          child: IconButton(
              icon: ImageIcon(
                AssetImage('assets/images/grid.png'),
                color: _selectedTab == SelectedTab.left
                    ? Colors.black
                    : Colors.black26,
              ),
              onPressed: () {
                _tabSelected(SelectedTab.left);
              }),
        ),
        Expanded(
          child: IconButton(
              icon: ImageIcon(
                AssetImage('assets/images/saved.png'),
                color: _selectedTab == SelectedTab.left
                    ? Colors.black26
                    : Colors.black,
              ),
              onPressed: () {
                _tabSelected(SelectedTab.right);
              }),
        ),
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _selectedTab = SelectedTab.left;
          _leftImagesPageMargin = 0;
          _rightImagesPageMargin = size.width;
          break;
        case SelectedTab.right:
          _selectedTab = SelectedTab.right;
          _leftImagesPageMargin = -size.width;
          _rightImagesPageMargin = 0;
          break;
      }
    });
  }

  Padding _editProfileBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: SizedBox(
        height: 24,
        child: OutlineButton(
          onPressed: () {},
          borderSide: BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(
            //끝이 둥글둥글한 직사각형을 만드는데
            borderRadius: BorderRadius.circular(6), // 그 둥글기가 어느정도냐
          ),
          child: Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _username(BuildContext context) {
    var userModel = Provider.of<UserModelState>(context).userModel;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        // 'sdsf',
        // Provider.of<UserModelState>(context).userModel.username,
        userModel == null ? "없음" : userModel.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
  //
  // Widget _username(BuildContext context) {
  //   UserModelState userModelState = Provider.of<UserModelState>(context);
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: common_gap),
  //     child: Text(
  //       userModelState == null || userModelState.userModel == null
  //           ? ""
  //           : userModelState.userModel.username,
  //       style: TextStyle(fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }

  Widget _userBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        'this is what i believe !',
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}

enum SelectedTab { left, right }
