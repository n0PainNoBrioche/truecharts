{{/* Define the secrets */}}
{{- define "reactiveresume.secrets" -}}
  {{- $secret := .Values.reactiveResume.secret -}}
enabled: true
data:
  AUTH_SECRET: {{ $secret.authSecret | quote }}
  ENCRYPTION_SECRET: {{ $secret.encryptionSecret | quote }}
  {{- with $secret.googleClientId }}
  GOOGLE_CLIENT_ID: {{ . | quote }}
  GOOGLE_CLIENT_SECRET: {{ $secret.googleClientSecret | quote }}
  {{- end }}
  {{- with $secret.githubClientId }}
  GITHUB_CLIENT_ID: {{ . | quote }}
  GITHUB_CLIENT_SECRET: {{ $secret.githubClientSecret | quote }}
  {{- end }}
  {{- with $secret.linkedinClientId }}
  LINKEDIN_CLIENT_ID: {{ . | quote }}
  LINKEDIN_CLIENT_SECRET: {{ $secret.linkedinClientSecret | quote }}
  {{- end }}
  {{- with $secret.oauthClientId }}
  OAUTH_CLIENT_ID: {{ . | quote }}
  OAUTH_CLIENT_SECRET: {{ $secret.oauthClientSecret | quote }}
  OAUTH_PROVIDER_NAME: {{ $secret.oauthProviderName | quote }}
  {{- end }}
  {{- with $secret.betterAuthApiKey }}
  BETTER_AUTH_API_KEY: {{ . | quote }}
  {{- end }}
  {{- with $secret.openaiAppsChallengeToken }}
  OPENAI_APPS_CHALLENGE_TOKEN: {{ . | quote }}
  {{- end }}
  {{- with $secret.googleCloudApiKey }}
  GOOGLE_CLOUD_API_KEY: {{ . | quote }}
  {{- end }}
  {{- with $secret.crowdinProjectId }}
  CROWDIN_PROJECT_ID: {{ . | quote }}
  CROWDIN_API_TOKEN: {{ $secret.crowdinApiToken | quote }}
  {{- end }}
  {{- with $secret.smtpUser }}
  SMTP_USER: {{ . | quote }}
  SMTP_PASS: {{ $secret.smtpPass | quote }}
  {{- end }}
{{- end -}}
