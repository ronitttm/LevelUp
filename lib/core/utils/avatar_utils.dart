class AvatarUtils {
  const AvatarUtils._();

  static const String _baseUrl = "https://api.dicebear.com/10.x/adventurer/png";

  static String url(String seed) {
    return "$_baseUrl?seed=$seed";
  }
}
