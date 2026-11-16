import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levelup_app/features/profile/providers/profile_provider.dart';
import '../../core/utils/avatar_utils.dart';
import '../../features/auth/providers/auth_controller.dart';

class TopBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return AppBar(
      centerTitle: true,
      elevation: 0,

      title: AnimatedTextKit(
        totalRepeatCount: 1,
        isRepeatingAnimation: false,
        animatedTexts: [
          TypewriterAnimatedText(
            'LevelUp',
            speed: const Duration(milliseconds: 180),
            cursor: "",
            textStyle: GoogleFonts.orbitron(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: profile.when(
            loading: () => const CircleAvatar(
              radius: 18,
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),

            error: (_, __) =>
                const CircleAvatar(radius: 18, child: Icon(Icons.person)),

            data: (user) => PopupMenuButton<String>(
              offset: const Offset(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                if (value == "profile") {
                  Navigator.pushNamed(context, "/profile");
                }

                if (value == "logout") {
                  try {
                    await ref.read(authControllerProvider.notifier).signOut();
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Could not sign out. Please try again.',
                          ),
                        ),
                      );
                    }
                  }
                }
              },

              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: "profile",
                  child: Row(
                    children: [
                      Icon(Icons.person_outline),
                      SizedBox(width: 10),
                      Text("Profile"),
                    ],
                  ),
                ),

                const PopupMenuItem(
                  value: "logout",
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 10),
                      Text("Logout"),
                    ],
                  ),
                ),
              ],

              child: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(AvatarUtils.url(user.avatarSeed)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
