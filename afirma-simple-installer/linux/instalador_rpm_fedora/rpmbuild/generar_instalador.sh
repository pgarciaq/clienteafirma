#!/bin/bash
# Genera el RPM de AutoFirma para Fedora.
# Debe ejecutarse desde este directorio (rpmbuild/).
set -e
TOPDIR="$(pwd)"
mkdir -p BUILD RPMS SRPMS

# Localizar los jar construidos con: mvn clean install -Denv=install
# (requiere Java 8: export JAVA_HOME=/usr/lib/jvm/java-8-temurin-jdk)
SIMPLE_JAR="$(pwd)/../../../afirma-simple/target/autofirma.jar"
CONFIG_JAR="$(pwd)/../../../afirma-ui-simple-configurator/target/autofirmaConfigurador.jar"

if [ ! -f BUILD/autofirma.jar ] && [ -f "$SIMPLE_JAR" ]; then
  echo "Copiando $(basename "$SIMPLE_JAR") a BUILD/"
  cp "$SIMPLE_JAR" BUILD/autofirma.jar
fi
if [ ! -f BUILD/autofirmaConfigurador.jar ] && [ -f "$CONFIG_JAR" ]; then
  echo "Copiando $(basename "$CONFIG_JAR") a BUILD/"
  cp "$CONFIG_JAR" BUILD/autofirmaConfigurador.jar
fi

for f in BUILD/autofirma.png BUILD/autofirma.jar BUILD/autofirmaConfigurador.jar BUILD/LICENSE; do
  if [ ! -f "$f" ]; then
    echo "ERROR: falta $f" >&2
    echo "Copie a BUILD/ los artefactos: autofirma.png, autofirma.jar, autofirmaConfigurador.jar, LICENSE" >&2
    exit 1
  fi
done

rpmbuild -bb SPECS/autofirma.spec --define "_topdir $TOPDIR"
