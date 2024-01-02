{{/*
Expand the name of the chart.
*/}}
{{- define "r1-nginx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "r1-nginx.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "r1-nginx.labels" -}}
{{ include "r1-nginx.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/component:  {{ .Values.labels.tier }}
app.kubernetes.io/part-of: frontend
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}
helm.sh/version: {{ .Chart.Version | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "r1-nginx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "r1-nginx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
gft.com/environment: {{ .Values.labels.environment }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "r1-nginx.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "r1-nginx.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "k8s-service-name" -}}
{{ include "r1-nginx.fullname" . }}
{{- end -}}