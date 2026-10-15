{{/* Define the config */}}
{{- define "meet.config" -}}
  {{- $cfg := .Values.meet.config -}}
  {{- $publicUrl := .Values.meet.publicUrl -}}
  {{- $publicHost := $publicUrl | trimPrefix "https://" | trimPrefix "http://" | trimSuffix "/" -}}
  {{- $redisUrl := "" -}}
  {{- if .Values.redis.enabled -}}
    {{- $redisUrl = printf "redis://%s:6379/1" (.Values.redis.creds.plainhost | trimAll "\"") -}}
  {{- end -}}
enabled: true
data:
  DJANGO_CONFIGURATION: {{ $cfg.djangoConfiguration | quote }}
  DJANGO_SETTINGS_MODULE: {{ $cfg.djangoSettingsModule | quote }}
  DJANGO_SILENCED_SYSTEM_CHECKS: {{ $cfg.djangoSilencedSystemChecks | quote }}
  {{- if $cfg.djangoCsrfTrustedOrigins }}
  DJANGO_CSRF_TRUSTED_ORIGINS: {{ $cfg.djangoCsrfTrustedOrigins | quote }}
  {{- else }}
  DJANGO_CSRF_TRUSTED_ORIGINS: {{ printf "%s,%s" $publicUrl $publicUrl | replace "https://" "https://" | quote }}
  {{- end }}
  {{- if $cfg.djangoAllowedHosts }}
  DJANGO_ALLOWED_HOSTS: {{ $cfg.djangoAllowedHosts | quote }}
  {{- else }}
  DJANGO_ALLOWED_HOSTS: {{ $publicHost | quote }}
  {{- end }}
  STORAGES_STATICFILES_BACKEND: django.contrib.staticfiles.storage.StaticFilesStorage
  OIDC_RP_SIGN_ALGO: {{ $cfg.oidcRpSignAlgo | quote }}
  OIDC_RP_SCOPES: {{ $cfg.oidcRpScopes | quote }}
  {{- with $cfg.oidcRedirectAllowedHosts }}
  OIDC_REDIRECT_ALLOWED_HOSTS: {{ . | quote }}
  {{- end }}
  {{- with $cfg.oidcAuthRequestExtraParams }}
  OIDC_AUTH_REQUEST_EXTRA_PARAMS: {{ . | quote }}
  {{- end }}
  {{- with $cfg.loginRedirectUrl }}
  LOGIN_REDIRECT_URL: {{ . | quote }}
  {{- end }}
  {{- with $cfg.loginRedirectUrlFailure }}
  LOGIN_REDIRECT_URL_FAILURE: {{ . | quote }}
  {{- end }}
  {{- with $cfg.logoutRedirectUrl }}
  LOGOUT_REDIRECT_URL: {{ . | quote }}
  {{- end }}
  ALLOW_UNREGISTERED_ROOMS: {{ $cfg.allowUnregisteredRooms | quote }}
  FRONTEND_SILENCE_LIVEKIT_DEBUG: {{ $cfg.frontendSilenceLivekitDebug | quote }}
  {{- with $cfg.livekitApiUrl }}
  LIVEKIT_API_URL: {{ . | quote }}
  {{- end }}
  {{/* Database */}}
  {{- if .Values.cnpg.main.enabled }}
  DB_HOST: {{ .Values.cnpg.main.creds.host | trimAll "\"" | quote }}
  DB_NAME: {{ .Values.cnpg.main.database | quote }}
  DB_USER: {{ .Values.cnpg.main.user | quote }}
  DB_PORT: "5432"
  {{- else if $cfg.databaseUrl }}
  DB_HOST: {{ $cfg.databaseUrl | trimPrefix "postgresql://" | trimPrefix "postgres://" | splitList "@" | last | splitList ":" | first | quote }}
  DB_NAME: {{ $cfg.databaseUrl | splitList "/" | last | splitList "?" | first | quote }}
  DB_USER: {{ $cfg.databaseUrl | trimPrefix "postgresql://" | trimPrefix "postgres://" | splitList ":" | first | quote }}
  DB_PORT: {{ $cfg.databaseUrl | trimPrefix "postgresql://" | trimPrefix "postgres://" | splitList "@" | last | splitList ":" | last | splitList "/" | first | quote }}
  {{- end }}
  {{/* Redis */}}
  {{- if $redisUrl }}
  REDIS_URL: {{ $redisUrl | quote }}
  {{- else if $cfg.redisUrl }}
  REDIS_URL: {{ $cfg.redisUrl | quote }}
  {{- end }}
  {{/* Email */}}
  {{- with $cfg.emailHost }}
  DJANGO_EMAIL_HOST: {{ . | quote }}
  DJANGO_EMAIL_PORT: {{ $cfg.emailPort | quote }}
  DJANGO_EMAIL_USE_SSL: {{ $cfg.emailUseSSL | quote }}
  {{- end }}
{{- end -}}
