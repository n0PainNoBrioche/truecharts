{{/* Define the secrets */}}
{{- define "penpot.secrets" -}}
  {{- $cfg := .Values.penpot -}}
enabled: true
data:
  PENPOT_SECRET_KEY: {{ $cfg.apiSecretKey | quote }}
  {{- if .Values.cnpg.main.enabled }}
  PENPOT_DATABASE_PASSWORD: {{ .Values.cnpg.main.creds.password | quote }}
  {{- else }}
  PENPOT_DATABASE_PASSWORD: {{ $cfg.postgresql.password | quote }}
  {{- end }}
  {{- if and (ne $cfg.objectsStorage.storageBackend "fs") $cfg.objectsStorage.s3.accessKeyID }}
  AWS_ACCESS_KEY_ID: {{ $cfg.objectsStorage.s3.accessKeyID | quote }}
  AWS_SECRET_ACCESS_KEY: {{ $cfg.objectsStorage.s3.secretAccessKey | quote }}
  {{- end }}
  {{- if $cfg.smtp.enabled }}
    {{- with $cfg.smtp.username }}
  PENPOT_SMTP_USERNAME: {{ . | quote }}
    {{- end }}
    {{- with $cfg.smtp.password }}
  PENPOT_SMTP_PASSWORD: {{ . | quote }}
    {{- end }}
  {{- end }}
  {{- if $cfg.providers.google.enabled }}
  PENPOT_GOOGLE_CLIENT_SECRET: {{ $cfg.providers.google.clientSecret | quote }}
  {{- end }}
  {{- if $cfg.providers.github.enabled }}
  PENPOT_GITHUB_CLIENT_SECRET: {{ $cfg.providers.github.clientSecret | quote }}
  {{- end }}
  {{- if $cfg.providers.gitlab.enabled }}
  PENPOT_GITLAB_CLIENT_SECRET: {{ $cfg.providers.gitlab.clientSecret | quote }}
  {{- end }}
  {{- if $cfg.providers.oidc.enabled }}
  PENPOT_OIDC_CLIENT_SECRET: {{ $cfg.providers.oidc.clientSecret | quote }}
  {{- end }}
  {{- if $cfg.providers.ldap.enabled }}
  PENPOT_LDAP_BIND_PASSWORD: {{ $cfg.providers.ldap.bindPassword | quote }}
  {{- end }}
{{- end -}}
