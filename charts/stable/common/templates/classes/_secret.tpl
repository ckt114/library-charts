{{/*
This template serves as a blueprint for all secret objects that are created
within the common library.
*/}}
{{- define "common.classes.secret" -}}
  {{- $fullName := include "common.names.fullname" . -}}
  {{- $secretName := $fullName -}}
  {{- $values := .Values.secret -}}

  {{- if hasKey . "ObjectValues" -}}
    {{- with .ObjectValues.secret -}}
      {{- $values = . -}}
    {{- end -}}
  {{ end -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $secretName = printf "%v-%v" $secretName $values.nameOverride -}}
  {{- end }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ $secretName }}
  {{- with (merge ($values.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
stringData:
{{- with $values.data }}
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
{{- end }}
