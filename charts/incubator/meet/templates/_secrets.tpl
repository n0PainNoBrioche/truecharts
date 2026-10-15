{{/* Define the secrets */}}
{{- define "meet.secrets" -}}
  {{- $secret := .Values.meet.secret -}}
enabled: true
data:
  DJANGO_SECRET_KEY: {{ $secret.djangoSecretKey | quote }}
  OIDC_OP_JWKS_ENDPOINT: {{ $secret.oidcOpJwksEndpoint | quote }}
  OIDC_OP_AUTHORIZATION_ENDPOINT: {{ $secret.oidcOpAuthorizationEndpoint | quote }}
  OIDC_OP_TOKEN_ENDPOINT: {{ $secret.oidcOpTokenEndpoint | quote }}
  OIDC_OP_USER_ENDPOINT: {{ $secret.oidcOpUserEndpoint | quote }}
  OIDC_OP_LOGOUT_ENDPOINT: {{ $secret.oidcOpLogoutEndpoint | quote }}
  OIDC_RP_CLIENT_ID: {{ $secret.oidcRpClientId | quote }}
  OIDC_RP_CLIENT_SECRET: {{ $secret.oidcRpClientSecret | quote }}
  LIVEKIT_API_KEY: {{ $secret.livekitApiKey | quote }}
  LIVEKIT_API_SECRET: {{ $secret.livekitApiSecret | quote }}
  {{- if and $secret.superuserEmail $secret.superuserPassword }}
  DJANGO_SUPERUSER_EMAIL: {{ $secret.superuserEmail | quote }}
  DJANGO_SUPERUSER_PASSWORD: {{ $secret.superuserPassword | quote }}
  {{- end }}
  {{- if .Values.cnpg.main.enabled }}
  DB_PASSWORD: {{ .Values.cnpg.main.creds.password | quote }}
  {{- else if .Values.meet.config.databaseUrl }}
  DB_PASSWORD: {{ .Values.meet.config.databaseUrl | trimPrefix "postgresql://" | trimPrefix "postgres://" | splitList "@" | first | splitList ":" | last | quote }}
  {{- end }}
{{- end -}}
