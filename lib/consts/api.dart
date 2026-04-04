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

// Keycloak / OAuth configuration
const String keycloakIssuerUrl = 'https://id.42.mk/realms/42mk';
const String keycloakClientId = 'mobile.42.mk';
const String keycloakRedirectUri = 'mk.42.mobileapp://redirect';
const String keycloakRegisterUrl =
    'https://id.42.mk/realms/42mk/protocol/openid-connect/registrations';
const String keycloakTokenEndpoint =
    'https://id.42.mk/realms/42mk/protocol/openid-connect/token';
