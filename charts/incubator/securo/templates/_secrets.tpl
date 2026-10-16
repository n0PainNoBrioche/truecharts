{{/* Define the secrets */}}
{{- define "securo.secrets" -}}
  {{- $fullname := (include "tc.v1.common.lib.chart.names.fullname" $) -}}
  {{- $cfg := .Values.securo.config -}}
enabled: true
data:
  {{- if .Values.cnpg.main.enabled }}
  DATABASE_URL: {{ printf "postgresql+asyncpg://%s:%s@%s:5432/%s" .Values.cnpg.main.user (urlquery .Values.cnpg.main.creds.password) (.Values.cnpg.main.creds.host | trimAll "\"") .Values.cnpg.main.database | quote }}
  {{- else if $cfg.databaseUrl }}
  DATABASE_URL: {{ $cfg.databaseUrl | quote }}
  {{- end }}
  {{- range $key, $value := .Values.securo.secret }}
    {{- if $value }}
  {{ $key | snakecase | upper }}: {{ $value | quote }}
    {{- end }}
  {{- end }}
{{- end -}}
