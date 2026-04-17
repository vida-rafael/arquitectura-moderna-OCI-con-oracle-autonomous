# ======================================
# OCI / Validación de Seguridad Básica
# ======================================
# Author: Rafael Pontes Vida
# Context: OCI + Autonomous Database
# ======================================

#!/bin/bash

AUTONOMOUS_DB_OCID="ocid1.autonomousdatabase.oc1..xxxx"

echo "Validando seguridad del Oracle Autonomous Database..."

ADB=$(oci db autonomous-database get \
  --autonomous-database-id "$AUTONOMOUS_DB_OCID")

ENDPOINT_PRIVADO=$(echo "$ADB" | jq -r '.data["private-endpoint"]')
CONTROL_ACCESO=$(echo "$ADB" | jq -r '.data["is-access-control-enabled"]')

echo "Endpoint privado  : $ENDPOINT_PRIVADO"
echo "Control de acceso : $CONTROL_ACCESO"

if [ "$ENDPOINT_PRIVADO" == "null" ]; then
  echo "Base de datos expuesta públicamente"
else
  echo "Endpoint privado configurado"
fi

if [ "$CONTROL_ACCESO" != "true" ]; then
  echo "Control de acceso no habilitado"
else
  echo "Control de acceso habilitado"
fi

echo "Validación de seguridad completada"
