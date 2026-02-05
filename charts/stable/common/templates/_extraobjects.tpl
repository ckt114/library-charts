{{/*
Renders the extra  objects required by the chart.
*/}}
{{- define "common.extraObjects" -}}
  {{- range .Values.extraObjects }}
---
    {{ tpl (toYaml .) $ | nindent 0 }}
  {{- end }}
{{- end }}
