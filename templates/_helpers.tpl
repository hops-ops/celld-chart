{{- define "celld.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "celld.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "celld.name" . -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "celld.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "celld.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "celld.selectorLabels" -}}
app.kubernetes.io/name: {{ include "celld.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "celld.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "celld.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{- define "celld.azurite.fullname" -}}
{{- printf "%s-azurite" (include "celld.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "celld.azurite.secretName" -}}
{{- printf "%s-azurite" (include "celld.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "celld.azurite.connectionString" -}}
DefaultEndpointsProtocol=http;AccountName={{ .Values.azurite.accountName }};AccountKey={{ .Values.azurite.accountKey }};BlobEndpoint=http://{{ include "celld.azurite.fullname" . }}:{{ .Values.azurite.blobPort }}/{{ .Values.azurite.accountName }};
{{- end -}}

{{- define "celld.sharedCredentials.enabled" -}}
{{- if .Values.credentials.sharedCredentialsSecret }}true{{- end -}}
{{- end -}}

{{- define "celld.sharedCredentials.path" -}}
/var/run/secrets/aws/credentials
{{- end -}}

{{- /* Parse hops/AWS CLI INI ([default] aws_access_key_id=...) into AWS_* env vars.
       object_store reads env keys, not the shared-credentials file. */ -}}
{{- define "celld.exportSharedCredentials.sh" -}}
if [ -f {{ include "celld.sharedCredentials.path" . | quote }} ]; then
  _creds={{ include "celld.sharedCredentials.path" . | quote }}
  AWS_ACCESS_KEY_ID=$(awk '/^\[/{p=0} /^\[default\]/{p=1; next} p && $0 ~ /^aws_access_key_id[[:space:]]*=/{ sub(/^[^=]*=[[:space:]]*/, ""); sub(/[[:space:]]+$/, ""); print; exit }' "$_creds")
  AWS_SECRET_ACCESS_KEY=$(awk '/^\[/{p=0} /^\[default\]/{p=1; next} p && $0 ~ /^aws_secret_access_key[[:space:]]*=/{ sub(/^[^=]*=[[:space:]]*/, ""); sub(/[[:space:]]+$/, ""); print; exit }' "$_creds")
  AWS_SESSION_TOKEN=$(awk '/^\[/{p=0} /^\[default\]/{p=1; next} p && $0 ~ /^aws_session_token[[:space:]]*=/{ sub(/^[^=]*=[[:space:]]*/, ""); sub(/[[:space:]]+$/, ""); print; exit }' "$_creds")
  export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
  if [ -n "${AWS_SESSION_TOKEN:-}" ]; then
    export AWS_SESSION_TOKEN
  fi
fi
{{- end -}}

{{- define "celld.sharedCredentials.volumeMount" -}}
- name: aws-shared-credentials
  mountPath: /var/run/secrets/aws
  readOnly: true
{{- end -}}

