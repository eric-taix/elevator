part of elevator;

final callUrl = new UrlPattern(r'/call');
final goUrl = new UrlPattern(r'/go');
final userHasEnteredUrl = new UrlPattern(r'/userHasEntered');
final userHasExitedUrl = new UrlPattern(r'/userHasExited');
final resetUrl = new UrlPattern(r'/reset');
final nextCommandUrl = new UrlPattern(r'/nextCommand');
final lastResetUrl = new UrlPattern(r'/stacktrace');

final allUrls = [callUrl, goUrl, userHasEnteredUrl, userHasExitedUrl, resetUrl, nextCommandUrl];

