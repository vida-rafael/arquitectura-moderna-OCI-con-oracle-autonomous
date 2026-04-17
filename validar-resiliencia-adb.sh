# =======================================================
# OCI / Validación de Alta Disponibilidad y Resiliencia
# =======================================================
# Author: Rafael Pontes Vida
# Context: OCI + Autonomous Database
# =======================================================

#!/bin/bash

AUTONOMOUS_DB_OCID="ocid1.autonomousdatabase.oc1..xxxx"

echo "Validando alta disponibilidad y resiliencia..."
echo "----------------------------------------------"

ADB=$(oci db autonomous-database get \
  --autonomous-database-id "$AUTONOMOUS_DB_OCID")

ESTADO=$(echo "$ADB" | jq -r '.data["lifecycle-state"]')
DATAGUARD_LOCAL=$(echo "$ADB" | jq -r '.data["is-local-data-guard-enabled"]')
BACKUPS_AUTO=$(echo "$ADB" | jq -r '.data["is-auto-backups-enabled"]')

echo "Estado              : $ESTADO"
echo "Data Guard local    : $DATAGUARD_LOCAL"
echo "Backups automáticos : $BACKUPS_AUTO"

if [ "$ESTADO" != "AVAILABLE" ]; then
  echo "Base de datos no disponible"
  exit 1
fi

if [ "$DATAGUARD_LOCAL" != "true" ]; then
  echo "Data Guard local NO habilitado"
else
  echo "Data Guard local habilitado"
fi

if [ "$BACKUPS_AUTO" != "true" ]; then
  echo "Backups automáticos deshabilitados"
  exit 1
fi

echo " Validación de resiliencia finalizada correctamente"
