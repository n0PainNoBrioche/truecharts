{{/* Define the config */}}
{{- define "reactiveresume.config" -}}
  {{- $cfg := .Values.reactiveResume.config -}}
  {{- $fullname := include "tc.v1.common.lib.chart.names.fullname" $ -}}
enabled: true
data:
  {{/* Database */}}
  {{- if .Values.cnpg.main.enabled }}
  DATABASE_URL: {{ printf "postgresql://%s:%s@%s:5432/%s" .Values.cnpg.main.user (urlquery .Values.cnpg.main.creds.password) .Values.cnpg.main.creds.host .Values.cnpg.main.database | quote }}
  {{- else if $cfg.databaseUrl }}
  DATABASE_URL: {{ $cfg.databaseUrl | quote }}
  {{- end }}
  {{/* Redis */}}
  {{- if .Values.redis.enabled }}
  REDIS_URL: {{ printf "redis://%s:6379" (.Values.redis.creds.plainhost | trimAll "\"") | quote }}
  {{- else if $cfg.redisUrl }}
  REDIS_URL: {{ $cfg.redisUrl | quote }}
  {{- end }}
  {{/* S3 storage */}}
  S3_ENDPOINT: {{ $cfg.s3Endpoint | default (printf "http://%s-seaweedfs:%v" $fullname .Values.service.seaweedfs.ports.seaweedfs.port) | quote }}
{{- end -}}
