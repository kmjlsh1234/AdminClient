part of '_topbar.dart';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({super.key});

  Future<void> logout(BuildContext context) async {
    final AdminService adminService = AdminService();
    dartz.Either<ErrorCode, bool> result = await adminService.logout();
    result.fold(
        (errorCode){
          ErrorDialog.showError(context, errorCode);
        },
        (isSuccess){
          if(isSuccess){
            GoRouter.of(context).go('/authentication/signin');
          }
        }
    );
  }

  void _showUserProfileDialog(BuildContext context) async {
    final AdminProvider adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final AdminService adminService = AdminService();
    Admin? admin = adminProvider.admin;
    if(admin==null){
      dartz.Either<ErrorCode, Admin> result = await adminService.getAdmin();
      result.fold(
          (errorCode){
            ErrorDialog.showError(context, errorCode);
          },
          (admin){
            adminProvider.setAdmin(admin);
          }
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: AdminProfileDialog(admin: admin!));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);


    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(60),
      child: DropdownButton2(
        underline: const SizedBox.shrink(),
        customButton: _buildButton(context),
        dropdownStyleData: _dropdownStyle.dropdownStyle.copyWith(
          width: responsiveValue<double>(
            context,
            xs: 200,
            md: 246,
          ),
          maxHeight: 425,
          offset: const Offset(0, -24),
          scrollbarTheme: _theme.scrollbarTheme.copyWith(
            thumbVisibility: WidgetStateProperty.all<bool>(false),
            trackVisibility: WidgetStateProperty.all<bool>(false),
          ),
        ),
        menuItemStyleData: _dropdownStyle.menuItemStyle.copyWith(
          customHeights: [60, 48, 48],
          padding: EdgeInsets.zero,
        ),
        items: [
          // Profile Tile
          DropdownMenuItem<String>(
            value: 'user_profile',
            child: _DropdownItemWrapper(
              child: Consumer<AdminProvider>(
                builder: (context, adminProvider, child){
                  final admin = adminProvider.admin;
                  return ListTile(
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Text(admin!.name),
                    titleTextStyle: _theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    subtitle: const Text('Admin'),
                    subtitleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                      color: _theme.colorScheme.onTertiaryContainer,
                    ),
                  );
                },
              )
            ),
          ),

          ...{
            "Profile": FeatherIcons.user,
            "Logout": FeatherIcons.power,
          }.entries.toList().asMap().entries.map((item) {
            return DropdownMenuItem(
              value: item.key,
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: _DropdownItemWrapper(
                  child: ListTile(
                    key: ValueKey(item.value),
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(item.value.value, size: 20),
                    title: Text(item.value.key),
                    titleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ),
            );
          })
        ],
        onChanged: (value) async {
          log('value : $value');
          if(value == 0){
            _showUserProfileDialog(context);
          } else if(value == 1){
            logout(context);
          }
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final _size = constraints.biggest;
        return SizedBox.square(
          dimension: _size.height / 2,
          child: const AvatarWidget(
            imagePath:
                'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_01.png',
          ),
        );
      },
    );
  }
}

class _DropdownItemWrapper extends StatelessWidget {
  const _DropdownItemWrapper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            color: _theme.colorScheme.outline,
          ),
        ),
      ),
      child: child,
    );
  }
}
