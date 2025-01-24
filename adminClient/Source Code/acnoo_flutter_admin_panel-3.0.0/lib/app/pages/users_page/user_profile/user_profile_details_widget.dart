// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/models/admin_user/admin_user_detail.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/fuctions/_get_image.dart';
import '../../../widgets/checkbox_form_field/_checkbox_form_field.dart';

class UserProfileDetailsWidget extends StatelessWidget {
  const UserProfileDetailsWidget({
    super.key,
    required double padding,
    required this.theme,
    required this.textTheme,
    required this.adminUserDetail
  }) : _padding = padding;

  final double _padding;
  final ThemeData theme;
  final TextTheme textTheme;
  final AdminUserDetail adminUserDetail;
  Widget _buildProfileDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Text(
                  ':',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailCheckBoxRow(String label, bool value) {
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          Expanded(
            flex: 4,
            child: Row(
                children: [
                  Checkbox(
                  value: value,
                  onChanged: (bool? value) {},
                ),
                ]
            )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          height: 178,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),

          child: getImageType(_userProfile.$1,
              fit: BoxFit.cover, alignment: Alignment.bottomCenter),
        ),
        const SizedBox(height: 70),
        Padding(
          padding: EdgeInsets.all(_padding),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: theme.colorScheme.outline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileDetailRow('${lang.fullName}', adminUserDetail.nickname),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.email, adminUserDetail.email),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.phoneNumber, adminUserDetail.mobile),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.status, adminUserDetail.status),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.userType, adminUserDetail.userType),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.loginAt, adminUserDetail.loginAt),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.logoutAt, adminUserDetail.logoutAt),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.createdAt, adminUserDetail.createdAt),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.updatedAt, adminUserDetail.updatedAt),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailCheckBoxRow(lang.agreeMarketing, adminUserDetail.agreeMarketing),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailCheckBoxRow(lang.agreePrivacy, adminUserDetail.agreePrivacy),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailCheckBoxRow(lang.agreeSensitive, adminUserDetail.agreeSensitive),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailCheckBoxRow(lang.agreementToTerms, adminUserDetail.agreeTerm),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.marketingModifiedAt, adminUserDetail.marketingModifiedAt),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const (String,) _userProfile =
    ('assets/images/static_images/background_images/background_image_08.png',);
