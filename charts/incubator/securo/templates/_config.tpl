{{/* Define the config */}}
{{- define "securo.config" -}}
  {{- $fullname := (include "tc.v1.common.lib.chart.names.fullname" $) -}}
  {{- $cfg := .Values.securo.config -}}
  {{- $frontendUrl := printf "%s://%s" (ternary "https" "http" .Values.securo.tls) .Values.securo.domain -}}
  {{- $redisUrl := "" -}}
  {{- if .Values.redis.enabled -}}
    {{- $redisUrl = .Values.redis.creds.url | trimAll "\"" -}}
  {{- end -}}
enabled: true
data:
  FRONTEND_URL: {{ $frontendUrl | quote }}
  PLUGGY_OAUTH_REDIRECT_URI: {{ $cfg.pluggyOauthRedirectUri | default (printf "%s/oauth/callback" $frontendUrl) | quote }}
  ENABLE_BANKING_OAUTH_REDIRECT_URI: {{ $cfg.enableBankingOauthRedirectUri | default (printf "%s/oauth/callback" $frontendUrl) | quote }}
  STORAGE_LOCAL_PATH: /app/data/attachments
  AGENTS_KNOWLEDGE_STORAGE_PATH: /app/data/agent_knowledge
  AGENTS_BUILTIN_MCP_URL: {{ printf "http://%s-mcpserver:%v/mcp" $fullname .Values.service.mcpserver.ports.mcpserver.port | quote }}
  AGENTS_EXTERNAL_MCP_URL: {{ printf "%s/mcp" $frontendUrl | quote }}
  {{- if and .Values.redis.enabled (not $cfg.redisUrl) }}
  REDIS_URL: {{ $redisUrl | quote }}
  CELERY_BROKER_URL: {{ $redisUrl | quote }}
  CELERY_RESULT_BACKEND: {{ $redisUrl | quote }}
  {{- else if $cfg.redisUrl }}
  REDIS_URL: {{ $cfg.redisUrl | quote }}
  CELERY_BROKER_URL: {{ $cfg.celeryBrokerUrl | default $cfg.redisUrl | quote }}
  CELERY_RESULT_BACKEND: {{ $cfg.celeryResultBackend | default $cfg.redisUrl | quote }}
  {{- end }}
  {{- range $key, $value := $cfg }}
    {{- if and (ne $key "pluggyOauthRedirectUri") (ne $key "enableBankingOauthRedirectUri") (ne $key "databaseUrl") (ne $key "redisUrl") (ne $key "celeryBrokerUrl") (ne $key "celeryResultBackend") }}
  {{ $key | snakecase | upper }}: {{ tpl (print $value) $ | quote }}
    {{- end }}
  {{- end }}
{{- end -}}
