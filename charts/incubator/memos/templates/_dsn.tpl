{{/* Define the DSN for the bundled CNPG postgres */}}
{{- define "memos.dsn" -}}
{{- $fullname := include "tc.v1.common.lib.chart.names.fullname" $ -}}
{{- printf "postgresql://%s:%s@%s:5432/%s?sslmode=disable" .Values.cnpg.main.user (urlquery .Values.cnpg.main.creds.password) .Values.cnpg.main.creds.host .Values.cnpg.main.database -}}
{{- end -}}
