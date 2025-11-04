import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';
import 'package:insan_jamd_hawan/services/image_picker_service.dart';

class PlayerInfo extends StatefulWidget {
  const PlayerInfo({super.key});

  static const String path = '/player-info';
  static const String name = 'PlayerInfo';

  @override
  State<PlayerInfo> createState() => _PlayerInfoState();
}

class _PlayerInfoState extends State<PlayerInfo> {
  final TextEditingController _usernameController = TextEditingController();
  final ImagePickerService _imagePickerService = ImagePickerService();
  String? _profileImagePath;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final imagePath = await _imagePickerService.pickImageFromGallery();
    if (imagePath != null) {
      setState(() {
        _profileImagePath = imagePath;
      });
    }
  }

  Future<void> _savePlayerInfo() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your username')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      debugPrint('Username: $username');
      debugPrint('Profile Image Path: $_profileImagePath');

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Player info saved successfully')),
        );
        // Navigate back or to next screen
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving player info: $e')));
      }
    }
  }

  Widget _buildProfileImagePicker() {
    return GestureDetector(
      onTap: _pickProfileImage,
      child: Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.kGray600, width: 2.w),
          color: AppColors.kGreen100,
        ),
        child: _profileImagePath != null
            ? ClipOval(
                child: kIsWeb
                    ? (_profileImagePath!.startsWith('blob:') ||
                              _profileImagePath!.startsWith('data:'))
                          ? Image.network(
                              _profileImagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholder();
                              },
                            )
                          : _buildPlaceholder()
                    : Image.file(
                        File(_profileImagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      ),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 40.sp, color: AppColors.kGray600),
          SizedBox(height: 8.h),
          Text(
            'Tap to add\nprofile image',
            textAlign: TextAlign.center,
            style: AppTypography.kRegular19.copyWith(
              fontSize: 12.sp,
              color: AppColors.kGray600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              leading: Padding(
                padding: EdgeInsets.all(10.h),
                child: CustomIconButton(
                  icon: AppAssets.backIcon,
                  onTap: () {
                    context.pop();
                  },
                ),
              ),
              actions: [
                CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
                SizedBox(width: 16.w),
              ],
            ),
      body: LobbyBg(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40.w : 16.w,
            vertical: isDesktop ? 20.h : 16.h,
          ),
          child: Center(
            child: DesktopWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isDesktop) SizedBox(height: 50.h),
                  GameLogo(),
                  SizedBox(height: 12.h),

                  Text(
                    "Set up your profile information below. Your username and welcome message will be visible to other players in the lobby.",
                    textAlign: TextAlign.center,
                    style: AppTypography.kRegular19.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.kGray600,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Center(child: _buildProfileImagePicker()),
                  SizedBox(height: 32.h),
                  TextField(
                    controller: _usernameController,
                    style: AppTypography.kRegular19.copyWith(fontSize: 16.sp),
                    enabled: !_isLoading,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter your username',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: PrimaryButton(
                      onPressed: _isLoading ? () {} : _savePlayerInfo,
                      text: _isLoading ? 'Loading...' : 'Save',
                      width: 220.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
