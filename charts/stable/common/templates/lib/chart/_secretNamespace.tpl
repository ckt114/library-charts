{{/*
Resolve the environment namespace used by shared resources.
Preview release namespaces use dev-scoped resources.
*/}}
{{- define "common.secretNamespace" -}}
{{- if contains "preview-" .Release.Namespace -}}
dev
{{- else -}}
{{- .Release.Namespace -}}
{{- end -}}
{{- end -}}
