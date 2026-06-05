{{/*
Renders the ExternalSecret objects required by the chart.
*/}}
{{- define "common.externalSecrets" -}}
  {{- range $name, $externalSecret := .Values.externalSecrets }}
    {{- $target := deepCopy ($externalSecret.target | default dict) -}}
    {{- if not (hasKey $target "creationPolicy") -}}
      {{- $_ := set $target "creationPolicy" "Owner" -}}
    {{- end -}}
    {{- if not (hasKey $target "deletionPolicy") -}}
      {{- $_ := set $target "deletionPolicy" "Delete" -}}
    {{- end }}
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ tpl (default $name $externalSecret.nameOverride) $ }}
  {{- with (merge ($externalSecret.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($externalSecret.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  secretStoreRef:
    name: {{ tpl (default "aws-clustersecretstore" $externalSecret.secretStoreRefName) $ }}
    kind: {{ tpl (default "ClusterSecretStore" $externalSecret.kind) $ }}
  dataFrom:
    {{- tpl (toYaml ($externalSecret.dataFrom | default list)) $ | nindent 4 }}
  data:
    {{- tpl (toYaml ($externalSecret.data | default list)) $ | nindent 4 }}
  refreshPolicy: {{ tpl (default "Periodic" $externalSecret.refreshPolicy) $ }}
  refreshInterval: {{ tpl (default "1h" $externalSecret.refreshInterval) $ }}
  target:
    {{- tpl (toYaml $target) $ | nindent 4 }}
  {{- end }}
{{- end }}
