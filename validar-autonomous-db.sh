# =======================================================
# OCI / Validación básica de Oracle Autonomous Database
# =======================================================
# Author: Rafael Pontes Vida
# Context: OCI + Autonomous Database
# =======================================================

#!/bin/bash

# ============================
# Configuración
# ============================
COMPARTMENT_OCID="ocid1.compartment.oc1..xxxx"
NOMBRE_AUTONOMOUS_DB="my-autonomous-db"

echo "Validando Oracle Autonomous Database..."
echo "----------------------------------------"

# ============================
# Obtener información del Autonomous DB
# ============================
ADB_INFO=$(oci db autonomous-database list \
  --compartment-id "$COMPARTMENT_OCID" \
  --query "data[?\"display-name\"=='$NOMBRE_AUTONOMOUS_DB'] | [0]")

if [ -z "$ADB_INFO" ]; then
  echo "Autonomous Database no encontrado."
  exit 1
fi

ESTADO=$(echo "$ADB_INFO" | jq -r '.lifecycle-state')
FREE_TIER=$(echo "$ADB_INFO" | jq -r '.is-free-tier')
CPU=$(echo "$ADB_INFO" | jq -r '.cpu-core-count')
STORAGE=$(echo "$ADB_INFO" | jq -r '.data-storage-size-in-gbs')
RETENCION_BACKUP=$(echo "$ADB_INFO" | jq -r '.backup-retention-period-in-days')

echo "Autonomous Database encontrado"
echo "Estado                 : $ESTADO"
echo "Free Tier              : $FREE_TIER"
echo "CPU Cores              : $CPU"
echo "Almacenamiento (GB)    : $STORAGE"
echo "Retención de Backup    : $RETENCION_BACKUP días"

# ============================
# Validaciones
# ============================
if [ "$ESTADO" != "AVAILABLE" ]; then
  echo " El Autonomous Database NO está disponible"
  exit 1
fi

if [ "$RETENCION_BACKUP" -lt 7 ]; then
  echo "Retención de backups inferior a 7 días"
fi

echo "Base de datos disponible y operativa"
echo "Validación básica completada con éxito"
``