const String baseUrl = 'https://cms.42.mk';
const String eventsApiUrl = '$baseUrl/api/events?sort=start:desc&populate=*';
const String usersApiUrl = '$baseUrl/api/users';
const String currentAuthenticatedUserApiUrl = '$baseUrl/api/users/me';
const String registerUserApiUrl = '$baseUrl/api/auth/local/register';
const String loginUserApiUrl = '$baseUrl/api/auth/local';
const String logoutUserApiUrl = '$baseUrl/api/auth/logout';
const String exchangeKeycloakTokenApiUrl =
    '$baseUrl/api/auth/keycloak/callback';
const String bookingSubmitApiUrl = '$baseUrl/api/event-requests/submit';
const String projectsApiUrl =
    'https://api.github.com/users/42dotmk/repos?sort=pushed&direction=desc&per_page=20';
const String githubApiBaseUrl = 'https://api.github.com';

String projectOpenPullRequestsApiUrl(String owner, String repo) {
  final query = Uri.encodeQueryComponent('repo:$owner/$repo is:pr is:open');
  return '$githubApiBaseUrl/search/issues?q=$query';
}

String projectHelpWantedIssuesApiUrl(String owner, String repo) {
  final query = Uri.encodeQueryComponent(
    'repo:$owner/$repo is:issue is:open label:"help wanted"',
  );
  return '$githubApiBaseUrl/search/issues?q=$query';
}

String projectContributorsApiUrl(String owner, String repo) {
  return '$githubApiBaseUrl/repos/$owner/$repo/contributors?per_page=20';
}

String projectCommitActivityApiUrl(String owner, String repo) {
  return '$githubApiBaseUrl/repos/$owner/$repo/stats/commit_activity';
}

// Keycloak / OAuth configuration
const String keycloakIssuerUrl = 'https://id.42.mk/realms/42mk';
const String keycloakClientId = 'mobile.42.mk';
const String keycloakRedirectUri = 'mk.42.mobileapp://redirect';
const String keycloakRegisterUrl =
    'https://id.42.mk/realms/42mk/protocol/openid-connect/registrations';
const String keycloakTokenEndpoint =
    'https://id.42.mk/realms/42mk/protocol/openid-connect/token';
