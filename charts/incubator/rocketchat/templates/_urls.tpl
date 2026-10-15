{{/* Define the MongoDB URL for Rocket.Chat */}}
{{- define "rocketchat.mongoUrl" -}}
{{- $fullname := include "tc.v1.common.lib.chart.names.fullname" $ -}}
{{- if and .Values.rocketchat.mongodb.enabled (not .Values.rocketchat.mongodb.mongoUrl) -}}
{{- printf "mongodb://%s:%s@%s-mongodb:%v/%s?replicaSet=rs0&authSource=admin" .Values.rocketchat.mongodb.username (urlquery .Values.rocketchat.mongodb.password) $fullname .Values.service.mongodb.ports.mongodb.targetPort .Values.rocketchat.mongodb.database -}}
{{- else -}}
{{- .Values.rocketchat.mongodb.mongoUrl | default (printf "mongodb://%s:%s@%s-mongodb:%v/%s?replicaSet=rs0&authSource=admin" .Values.rocketchat.mongodb.username (urlquery .Values.rocketchat.mongodb.password) $fullname .Values.service.mongodb.ports.mongodb.targetPort .Values.rocketchat.mongodb.database) -}}
{{- end -}}
{{- end -}}

{{/* Define the MongoDB oplog URL for Rocket.Chat */}}
{{- define "rocketchat.mongoOplogUrl" -}}
{{- $fullname := include "tc.v1.common.lib.chart.names.fullname" $ -}}
{{- if and .Values.rocketchat.mongodb.enabled (not .Values.rocketchat.mongodb.mongoOplogUrl) -}}
{{- printf "mongodb://%s:%s@%s-mongodb:%v/local?replicaSet=rs0&authSource=admin" .Values.rocketchat.mongodb.username (urlquery .Values.rocketchat.mongodb.password) $fullname .Values.service.mongodb.ports.mongodb.targetPort -}}
{{- else -}}
{{- .Values.rocketchat.mongodb.mongoOplogUrl | default (printf "mongodb://%s:%s@%s-mongodb:%v/local?replicaSet=rs0&authSource=admin" .Values.rocketchat.mongodb.username (urlquery .Values.rocketchat.mongodb.password) $fullname .Values.service.mongodb.ports.mongodb.targetPort) -}}
{{- end -}}
{{- end -}}

{{/* Define the SMTP mail URL for Rocket.Chat */}}
{{- define "rocketchat.mailUrl" -}}
{{- if .Values.rocketchat.smtp.enabled -}}
{{- if .Values.rocketchat.smtp.username -}}
{{- printf "smtps://%s:%s@%s:%v" .Values.rocketchat.smtp.username (urlquery .Values.rocketchat.smtp.password) .Values.rocketchat.smtp.host (.Values.rocketchat.smtp.port | int) -}}
{{- else -}}
{{- printf "smtp://%s:%v" .Values.rocketchat.smtp.host (.Values.rocketchat.smtp.port | int) -}}
{{- end -}}
{{- else -}}
{{- printf "smtp://localhost:25" -}}
{{- end -}}
{{- end -}}
