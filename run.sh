#!/usr/bin/env bash

VALIDATOR_PATH=./validator_cli.jar
VALIDATOR_OPTS=

SRC_PREFIX=
TGT_PREFIX=
RESOURCE_TYPE=Patient

SD_SRC_URL=
SD_TGT_URL=
SM_DEF_URL=
SM_FILENAME=
SM_FML_FILE=
SM_XML_FILE=
SD_SRC_IG=
SD_TGT_IG=
EXAMPLE_IN_FILE=
EXAMPLE_OUT_FILE=

SOURCE_DIR=./source
EXAMPLE_DIR=./example
MAPS_DIR=./map
OUTPUT_DIR=./output

_SM_FILENAME="\${SRC_PREFIX}-\${TGT_PREFIX}_\${RESOURCE_TYPE}"
_SM_FML_FILE="\${MAPS_DIR}/\${SM_FILENAME}.map"
_SM_XML_FILE="\${OUTPUT_DIR}/\${SM_FILENAME}.StructureMap.xml"

_SD_SRC_IG="\${SOURCE_DIR}/\${SRC_PREFIX}-\${RESOURCE_TYPE}.StructureDefinition.xml"
_SD_TGT_IG="\${SOURCE_DIR}/\${TGT_PREFIX}-\${RESOURCE_TYPE}.StructureDefinition.xml"

_EXAMPLE_IN_FILE="\${EXAMPLE_DIR}/\${SRC_PREFIX}-Example.\${RESOURCE_TYPE}.xml"
_EXAMPLE_OUT_FILE="\${OUTPUT_DIR}/\${TGT_PREFIX}-Example.\${RESOURCE_TYPE}.xml"

function updateVars() {
  SM_FILENAME=`eval echo ${_SM_FILENAME}`
  SM_FML_FILE=`eval echo ${_SM_FML_FILE}`
  SM_XML_FILE=`eval echo ${_SM_XML_FILE}`
  SD_SRC_IG=`eval echo ${_SD_SRC_IG}`
  SD_TGT_IG=`eval echo ${_SD_TGT_IG}`
  EXAMPLE_IN_FILE=`eval echo ${_EXAMPLE_IN_FILE}`
  EXAMPLE_OUT_FILE=`eval echo ${_EXAMPLE_OUT_FILE}`
}

function compile() {
  updateVars
  java ${VALIDATOR_OPTS} -jar ${VALIDATOR_PATH} \
    -ig ${SD_SRC_IG} \
    -ig ${SD_TGT_IG} \
    -ig ${SM_FML_FILE} \
    -compile ${SM_DEF_URL} \
    -output ${SM_XML_FILE}
}

function transform() {
  updateVars
  java ${VALIDATOR_OPTS} -jar ${VALIDATOR_PATH} ${EXAMPLE_IN_FILE} \
    -transform ${SM_DEF_URL} \
    -ig ${SD_SRC_IG} \
    -ig ${SD_TGT_IG} \
    -ig ${SM_XML_FILE} \
    -output ${EXAMPLE_OUT_FILE}
}

function validate() {
  updateVars
  local BASISPROFIL_PKG_VER=${1:-"1.4.0"}

  java ${VALIDATOR_OPTS} -jar ${VALIDATOR_PATH} ${EXAMPLE_OUT_FILE} \
    -level warnings \
    -best-practice warning \
    -version 4.0.1 \
    -ig ${SD_TGT_IG} \
    -ig de.basisprofil.r4#${BASISPROFIL_PKG_VER} \
    -profile ${SD_TGT_URL}
}

function download() {
  local OUTPUT=${1}
  local URL=${2}
  local MSG=${3}

  [ ! -f ${OUTPUT} ] && echo ${MSG} && curl -s -L -o ${OUTPUT} ${URL}
}

# Check installed CLI tools
[ -z "$(which curl)" ] && echo "[ERROR] Require curl to prepare compatibility checks (please install curl)"
[ -z "$(which java)" ] && echo "[ERROR] Require java runtime environment to perform compatibility checks (please install JRE)"

# Dowload the latest FHIR CLI validator
download "${VALIDATOR_PATH}" "https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar" "[INFO] Download latest FHIR CLI validator"

# Download FHIR Patient StructureDefinition and example files
download "${EXAMPLE_DIR}/AWS-Example.Patient.xml" "https://simplifier.net/ui/packagefile/downloadas?packageFileId=775391&format=xml" "[INFO] Download KBV AWS FHIR Patient example"
download "${SOURCE_DIR}/AWS-Patient.StructureDefinition.xml" "https://simplifier.net/ui/packagefile/downloadsnapshotas?packageFileId=775417&format=xml" "[INFO] Download KBV AWS FHIR Patient StructureDefinition"
download "${SOURCE_DIR}/ISiK-Patient.StructureDefinition.xml" "https://simplifier.net/ui/packagefile/downloadsnapshotas?packageFileId=2047391&format=xml" "[INFO] Download Gematik ISiK Basismodul FHIR Patient StructureDefinition"
download "${SOURCE_DIR}/KDS-Patient.StructureDefinition.xml" "https://simplifier.net/ui/packagefile/downloadsnapshotas?packageFileId=525898&format=xml" "[INFO] Download MII KDS Person FHIR Patient StructureDefinition"

# AWS to ISiK Patient
SRC_PREFIX=AWS
TGT_PREFIX=ISiK
SD_SRC_URL=https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Patient
SD_TGT_URL=https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKPatient
SM_DEF_URL=http://mihubx.de/fhir/StructureMap/MHX_SM_AwsToIsik
compile && transform && validate "1.4.0"

# ISiK to KDS Patient
SRC_PREFIX=ISiK
TGT_PREFIX=KDS
SD_SRC_URL=https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKPatient
SD_TGT_URL=https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient
SM_DEF_URL=http://mihubx.de/fhir/StructureMap/MHX_SM_IsikToKds
EXAMPLE_DIR=${OUTPUT_DIR}
compile && transform && validate "0.9.13"