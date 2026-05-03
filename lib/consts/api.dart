const String baseUrl = 'https://cms.42.mk';
const String eventsApiUrl = '$baseUrl/api/events?sort=start:desc&populate=*';
const String usersApiUrl = '$baseUrl/api/users';
const String currentAuthenticatedUserApiUrl =
    '$baseUrl/api/users/me?populate=profilePicture';
const String registerUserApiUrl = '$baseUrl/api/auth/local/register';
const String loginUserApiUrl = '$baseUrl/api/auth/local';
const String logoutUserApiUrl = '$baseUrl/api/auth/logout';
const String updateUserApiUrl = '$baseUrl/api/profile/update';
const String uploadImageApiUrl = '$baseUrl/api/upload';
const String exchangeKeycloakTokenApiUrl =
    '$baseUrl/api/auth/keycloak/callback';
const String bookingSubmitApiUrl = '$baseUrl/api/event-requests/submit';
const String changeAttendanceStatusApiUrl =
    '$baseUrl/api/user-events/change-status';
const String userEventsApiUrl = '$baseUrl/api/user-events/me';
const String projectsApiUrl = '$baseUrl/api/projects';

// Keycloak / OAuth configuration
const String keycloakIssuerUrl = 'https://id.42.mk/realms/42mk';
const String keycloakClientId = 'mobile.42.mk';
const String keycloakRedirectUri = 'mk.42.mobileapp://redirect';
const String keycloakRegisterUrl =
    'https://id.42.mk/realms/42mk/protocol/openid-connect/registrations';
const String keycloakTokenEndpoint =
    'https://id.42.mk/realms/42mk/protocol/openid-connect/token';
