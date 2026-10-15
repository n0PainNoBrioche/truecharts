{{/* Define the config */}}
{{- define "penpot.config" -}}
  {{- $cfg := .Values.penpot -}}
  {{- $redisUri := "" -}}
  {{- if .Values.redis.enabled -}}
    {{- $redisUri = .Values.redis.creds.url | trimAll "\"" -}}
  {{- end -}}
enabled: true
data:
  PENPOT_FLAGS: {{ $cfg.flags | quote }}
  PENPOT_PUBLIC_URI: {{ $cfg.publicUri | quote }}
  PENPOT_TELEMETRY_ENABLED: {{ $cfg.telemetryEnabled | quote }}
  PENPOT_TELEMETRY_REFERER: kubernetes
  PENPOT_FILE_DATA_BACKEND: {{ $cfg.fileDataBackend | quote }}
  PENPOT_HTTP_SERVER_MAX_BODY_SIZE: {{ $cfg.httpServerMaxBodySize | quote }}
  PENPOT_AUTO_FILE_SNAPSHOT_EVERY: {{ $cfg.autoFileSnapshot.every | quote }}
  PENPOT_AUTO_FILE_SNAPSHOT_TIMEOUT: {{ $cfg.autoFileSnapshot.timeout | quote }}
  {{- with $cfg.registrationDomainWhitelist }}
  PENPOT_REGISTRATION_DOMAIN_WHITELIST: {{ . | quote }}
  {{- end }}
  {{- with $cfg.termsOfServicesUri }}
  PENPOT_TERMS_OF_SERVICE_URI: {{ . | quote }}
  {{- end }}
  {{- with $cfg.privacyPolicyUri }}
  PENPOT_PRIVACY_POLICY_URI: {{ . | quote }}
  {{- end }}
  {{/* Database */}}
  {{- if .Values.cnpg.main.enabled }}
  PENPOT_DATABASE_URI: {{ printf "postgresql://%s:5432/%s" (.Values.cnpg.main.creds.host | trimAll "\"") .Values.cnpg.main.database | quote }}
  PENPOT_DATABASE_USERNAME: {{ .Values.cnpg.main.user | quote }}
  {{- else }}
  PENPOT_DATABASE_URI: {{ printf "postgresql://%s:%v/%s" $cfg.postgresql.host $cfg.postgresql.port $cfg.postgresql.database | quote }}
  PENPOT_DATABASE_USERNAME: {{ $cfg.postgresql.username | quote }}
  {{- end }}
  {{/* Redis */}}
  {{- if $redisUri }}
  PENPOT_REDIS_URI: {{ $redisUri | quote }}
  {{- else if $cfg.redisUri }}
  PENPOT_REDIS_URI: {{ $cfg.redisUri | quote }}
  {{- end }}
  {{/* Objects storage */}}
  PENPOT_OBJECTS_STORAGE_BACKEND: {{ $cfg.objectsStorage.storageBackend | quote }}
  {{- if eq $cfg.objectsStorage.storageBackend "fs" }}
  PENPOT_OBJECTS_STORAGE_FS_DIRECTORY: {{ $cfg.objectsStorage.filesystem.directory | quote }}
  {{- else }}
  PENPOT_OBJECTS_STORAGE_S3_REGION: {{ $cfg.objectsStorage.s3.region | quote }}
  PENPOT_OBJECTS_STORAGE_S3_BUCKET: {{ $cfg.objectsStorage.s3.bucket | quote }}
  PENPOT_OBJECTS_STORAGE_S3_ENDPOINT: {{ $cfg.objectsStorage.s3.endpointURI | quote }}
  {{- end }}
  {{/* SMTP */}}
  {{- if $cfg.smtp.enabled }}
    {{- with $cfg.smtp.defaultFrom }}
  PENPOT_SMTP_DEFAULT_FROM: {{ . | quote }}
    {{- end }}
    {{- with $cfg.smtp.defaultReplyTo }}
  PENPOT_SMTP_DEFAULT_REPLY_TO: {{ . | quote }}
    {{- end }}
    {{- with $cfg.smtp.host }}
  PENPOT_SMTP_HOST: {{ . | quote }}
    {{- end }}
    {{- with $cfg.smtp.port }}
  PENPOT_SMTP_PORT: {{ . | quote }}
    {{- end }}
  PENPOT_SMTP_TLS: {{ $cfg.smtp.tls | quote }}
  PENPOT_SMTP_SSL: {{ $cfg.smtp.ssl | quote }}
  {{- end }}
  {{/* Auth providers */}}
  {{- if $cfg.providers.google.enabled }}
  PENPOT_GOOGLE_CLIENT_ID: {{ $cfg.providers.google.clientID | quote }}
  {{- end }}
  {{- if $cfg.providers.github.enabled }}
  PENPOT_GITHUB_CLIENT_ID: {{ $cfg.providers.github.clientID | quote }}
  {{- end }}
  {{- if $cfg.providers.gitlab.enabled }}
  PENPOT_GITLAB_BASE_URI: {{ $cfg.providers.gitlab.baseURI | quote }}
  PENPOT_GITLAB_CLIENT_ID: {{ $cfg.providers.gitlab.clientID | quote }}
  {{- end }}
  {{- if $cfg.providers.oidc.enabled }}
    {{- with $cfg.providers.oidc.baseURI }}
  PENPOT_OIDC_BASE_URI: {{ . | quote }}
    {{- end }}
  PENPOT_OIDC_CLIENT_ID: {{ $cfg.providers.oidc.clientID | quote }}
    {{- with $cfg.providers.oidc.authURI }}
  PENPOT_OIDC_AUTH_URI: {{ . | quote }}
    {{- end }}
    {{- with $cfg.providers.oidc.tokenURI }}
  PENPOT_OIDC_TOKEN_URI: {{ . | quote }}
    {{- end }}
    {{- with $cfg.providers.oidc.userURI }}
  PENPOT_OIDC_USER_URI: {{ . | quote }}
    {{- end }}
    {{- with $cfg.providers.oidc.roles }}
  PENPOT_OIDC_ROLES: {{ . | quote }}
    {{- end }}
    {{- with $cfg.providers.oidc.rolesAttribute }}
  PENPOT_OIDC_ROLES_ATTR: {{ . | quote }}
    {{- end }}
    {{- with $cfg.providers.oidc.scopes }}
  PENPOT_OIDC_SCOPES: {{ . | quote }}
    {{- end }}
    {{- with $cfg.providers.oidc.nameAttribute }}
  PENPOT_OIDC_NAME_ATTR: {{ . | quote }}
    {{- end }}
    {{- with $cfg.providers.oidc.emailAttribute }}
  PENPOT_OIDC_EMAIL_ATTR: {{ . | quote }}
    {{- end }}
    {{- with $cfg.providers.oidc.userInfoSource }}
  PENPOT_OIDC_USER_INFO_SOURCE: {{ . | quote }}
    {{- end }}
  {{- end }}
  {{- if $cfg.providers.ldap.enabled }}
  PENPOT_LDAP_HOST: {{ $cfg.providers.ldap.host | quote }}
  PENPOT_LDAP_PORT: {{ $cfg.providers.ldap.port | quote }}
  PENPOT_LDAP_SSL: {{ $cfg.providers.ldap.ssl | quote }}
  PENPOT_LDAP_STARTTLS: {{ $cfg.providers.ldap.startTLS | quote }}
    {{- with $cfg.providers.ldap.baseDN }}
  PENPOT_LDAP_BASE_DN: {{ . | quote }}
    {{- end }}
    {{- with $cfg.providers.ldap.bindDN }}
  PENPOT_LDAP_BIND_DN: {{ . | quote }}
    {{- end }}
    {{- with $cfg.providers.ldap.userQuery }}
  PENPOT_LDAP_USER_QUERY: {{ . | quote }}
    {{- end }}
  PENPOT_LDAP_ATTRS_USERNAME: {{ $cfg.providers.ldap.attributesUsername | quote }}
  PENPOT_LDAP_ATTRS_EMAIL: {{ $cfg.providers.ldap.attributesEmail | quote }}
  PENPOT_LDAP_ATTRS_FULLNAME: {{ $cfg.providers.ldap.attributesFullname | quote }}
  PENPOT_LDAP_ATTRS_PHOTO: {{ $cfg.providers.ldap.attributesPhoto | quote }}
  {{- end }}
{{- end -}}

{{/* Define the redis config, used by workloads that only need the redis URI */}}
{{- define "penpot.redisConfig" -}}
  {{- $redisUri := "" -}}
  {{- if .Values.redis.enabled -}}
    {{- $redisUri = .Values.redis.creds.url | trimAll "\"" -}}
  {{- end -}}
enabled: true
data:
  {{- if $redisUri }}
  PENPOT_REDIS_URI: {{ $redisUri | quote }}
  PENPOT_MCP_REDIS_URI: {{ $redisUri | quote }}
  {{- else if .Values.penpot.redisUri }}
  PENPOT_REDIS_URI: {{ .Values.penpot.redisUri | quote }}
  PENPOT_MCP_REDIS_URI: {{ .Values.penpot.redisUri | quote }}
  {{- end }}
{{- end -}}
