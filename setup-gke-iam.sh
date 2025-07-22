#!/bin/bash

# GKE IAM Setup Script
# Verwendung: ./setup-gke-iam.sh PROJECT_ID ADMIN_EMAIL READER_EMAIL

set -e

# Parameter prüfen
if [ "$#" -ne 3 ]; then
    echo "Verwendung: $0 PROJECT_ID ADMIN_EMAIL READER_EMAIL"
    echo "Beispiel: $0 mein-gcp-project admin@example.com reader@example.com"
    exit 1
fi

PROJECT_ID="$1"
ADMIN_EMAIL="$2"
READER_EMAIL="$3"

echo "=== GKE IAM Setup ==="
echo "Project: $PROJECT_ID"
echo "Admin User: $ADMIN_EMAIL"
echo "Reader User: $READER_EMAIL"
echo ""

# Admin User Berechtigungen setzen
echo "Setze Admin-Berechtigungen für $ADMIN_EMAIL..."

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$ADMIN_EMAIL" \
  --role="roles/container.clusterAdmin" \
  --quiet

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$ADMIN_EMAIL" \
  --role="roles/container.developer" \
  --quiet

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$ADMIN_EMAIL" \
  --role="roles/compute.viewer" \
  --quiet

echo "✅ Admin-Berechtigungen gesetzt"

# Reader User Berechtigungen setzen
echo "Setze Reader-Berechtigungen für $READER_EMAIL..."

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$READER_EMAIL" \
  --role="roles/container.clusterViewer" \
  --quiet

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$READER_EMAIL" \
  --role="roles/container.developer" \
  --quiet

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$READER_EMAIL" \
  --role="roles/compute.viewer" \
  --quiet

echo "✅ Reader-Berechtigungen gesetzt"

# Berechtigungen anzeigen
echo ""
echo "=== Gesetzte Berechtigungen ==="
gcloud projects get-iam-policy "$PROJECT_ID" \
  --flatten="bindings[].members" \
  --format="table(bindings.role,bindings.members)" \
  --filter="bindings.role:(roles/container.clusterAdmin OR roles/container.clusterViewer OR roles/container.developer OR roles/compute.viewer) AND (bindings.members:$ADMIN_EMAIL OR bindings.members:$READER_EMAIL)"

echo ""
echo "=== Setup abgeschlossen ==="
echo "Die Benutzer können sich nun mit folgenden Befehlen am Cluster anmelden:"
echo ""
echo "Admin User ($ADMIN_EMAIL):"
echo "  gcloud container clusters get-credentials CLUSTER_NAME --zone=ZONE --project=$PROJECT_ID"
echo "  kubectl get nodes  # Vollzugriff"
echo ""
echo "Reader User ($READER_EMAIL):"
echo "  gcloud container clusters get-credentials CLUSTER_NAME --zone=ZONE --project=$PROJECT_ID"
echo "  kubectl get pods --all-namespaces  # Read-Only Zugriff"