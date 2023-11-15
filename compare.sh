#!/usr/bin/env bash

VALIDATOR_PATH=./validator_cli.jar
VALIDATOR_OPTS="-debug"
OUTPUT_DIR=./output/profile_comparision_reports
TMP_DIR=${TMPDIR}/generated_profile_comparision_report

function validate () {
  local lpkg=$1
  local lpkg_v=$2
  local lprof=$3
  local rpkg=$4
  local rpkg_v=$5
  local rprof=$6
  local output=${7:-${TMP_DIR}}
  local version=${8:-4.0.1}
  local dest="${output}/${lpkg}_${lpkg_v}-${rpkg}_${rpkg_v}"

  mkdir -p ${dest} && \
  java -jar ${VALIDATOR_PATH} ${VALIDATOR_OPTS} \
       -version ${version} \
       -compare \
       -dest ${dest} \
       -ig ${lpkg}\#${lpkg_v} -left ${lprof} \
       -ig ${rpkg}\#${rpkg_v} -right ${rprof}
}

function compare_patient_profiles () {
  echo "[INFO] Perform FHIR patient profile comparision of AWS 1.2.0 vs. ISiK Basismodul 3.0.0"
  validate "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Patient" \
           "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKPatient"
  
  echo "[INFO] Perform FHIR patient profile comparision of AWS 1.2.0 vs. MIO Basis-Profile 1.1.1"
  validate "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Patient" \
           "kbv.basis" "1.1.1" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Patient"
  
  echo "[INFO] Perform FHIR patient profile comparision of AWS 1.2.0 vs. MIO Basis-Profile 1.4.0"
  validate "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Patient" \
           "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Patient"
  
  echo "[INFO] Perform FHIR patient profile comparision of AWS 1.2.0 vs. MII KDS Person 1.0.17"
  validate "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Patient" \
           "de.medizininformatikinitiative.kerndatensatz.person" "1.0.17" "https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient"
  
  echo "[INFO] Perform FHIR patient profile comparision of ISiK Basismodul 3.0.0 vs. AWS 1.2.0"
  validate "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKPatient" \
           "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Patient"
  
  echo "[INFO] Perform FHIR patient profile comparision of ISiK Basismodul 3.0.0 vs. MIO Basis-Profile 1.4.0"
  validate "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKPatient" \
           "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Patient"
  
  echo "[INFO] Perform FHIR patient profile comparision of ISiK Basismodul 3.0.0 vs. MII KDS Person 1.0.17"
  validate "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKPatient" \
           "de.medizininformatikinitiative.kerndatensatz.person" "1.0.17" "https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient"
  
  echo "[INFO] Perform FHIR patient profile comparision of MIO Basis-Profile 1.4.0 vs. AWS 1.2.0"
  validate "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Patient" \
           "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Patient"
  
  echo "[INFO] Perform FHIR patient profile comparision of MIO Basis-Profile 1.4.0 vs. ISiK Basismodul 3.0.0"
  validate "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Patient" \
           "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKPatient"
  
  echo "[INFO] Perform FHIR patient profile comparision of MIO 1.4.0 vs. MII KDS Person 1.0.17"
  validate "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Patient" \
           "de.medizininformatikinitiative.kerndatensatz.person" "1.0.17" "https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient"
  
  echo "[INFO] Perform FHIR patient profile comparision of MII KDS Person 1.0.17 vs. AWS 1.2.0"
  validate "de.medizininformatikinitiative.kerndatensatz.person" "1.0.17" "https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient" \
           "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Patient"
  
  echo "[INFO] Perform FHIR patient profile comparision of MII KDS Person 1.0.17 vs. ISiK Basismodul 3.0.0"
  validate "de.medizininformatikinitiative.kerndatensatz.person" "1.0.17" "https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient" \
           "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKPatient"
  
  echo "[INFO] Perform FHIR patient profile comparision of MII KDS Person 1.0.17 vs. MIO Basis-Profile 1.4.0"
  validate "de.medizininformatikinitiative.kerndatensatz.person" "1.0.17" "https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient" \
           "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Patient"
}

function compare_diagnose_profiles () {
  echo "[INFO] Perform FHIR diagnose profile comparision of AWS 1.2.0 vs. ISiK Basismodul 3.0.0"
  validate "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Diagnose" \
           "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKDiagnose"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of AWS 1.2.0 vs. MIO Basis-Profile 1.1.1"
  validate "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Diagnose" \
           "kbv.basis" "1.1.1" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Condition_Diagnosis"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of AWS 1.2.0 vs. MIO Basis-Profile 1.4.0"
  validate "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Diagnose" \
           "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Condition_Diagnosis"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of AWS 1.2.0 vs. MII KDS Diagnose 1.0.4"
  validate "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Diagnose" \
           "de.medizininformatikinitiative.kerndatensatz.diagnose" "1.0.4" "https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of ISiK Basismodul 3.0.0 vs. AWS 1.2.0"
  validate "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKDiagnose" \
           "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Diagnose"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of ISiK Basismodul 3.0.0 vs. MIO Basis-Profile 1.4.0"
  validate "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKDiagnose" \
           "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Condition_Diagnosis"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of ISiK Basismodul 3.0.0 vs. MII KDS Diagnose 1.0.4"
  validate "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKDiagnose" \
           "de.medizininformatikinitiative.kerndatensatz.diagnose" "1.0.4" "https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of MIO Basis-Profile 1.4.0 vs. AWS 1.2.0"
  validate "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Condition_Diagnosis" \
           "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Diagnose"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of MIO Basis-Profile 1.4.0 vs. ISiK Basismodul 3.0.0"
  validate "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Condition_Diagnosis" \
           "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKDiagnose"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of MIO 1.4.0 vs. MII KDS Diagnose 1.0.4"
  validate "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Condition_Diagnosis" \
           "de.medizininformatikinitiative.kerndatensatz.diagnose" "1.0.4" "https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of MII KDS Diagnose 1.0.4 vs. AWS 1.2.0"
  validate "de.medizininformatikinitiative.kerndatensatz.diagnose" "1.0.4" "https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose" \
           "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Diagnose"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of MII KDS Diagnose 1.0.4 vs. ISiK Basismodul 3.0.0"
  validate "de.medizininformatikinitiative.kerndatensatz.diagnose" "1.0.4" "https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose" \
           "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKDiagnose"
  
  echo "[INFO] Perform FHIR diagnose profile comparision of MII KDS Diagnose 1.0.4 vs. MIO Basis-Profile 1.4.0"
  validate "de.medizininformatikinitiative.kerndatensatz.diagnose" "1.0.4" "https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose" \
           "kbv.basis" "1.4.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_Base_Condition_Diagnosis"
}

function compare_coverage_profiles () {
  echo "[INFO] Perform FHIR coverage profile comparision of AWS 1.2.0 vs. ISiK Basismodul 3.0.0 GKV"
  validate "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Krankenversicherungsverhaeltnis" \
           "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKVersicherungsverhaeltnisGesetzlich" \
           "${TMP_DIR}/coverage/gkv"

  echo "[INFO] Perform FHIR coverage profile comparision of AWS 1.2.0 vs. ISiK Basismodul 3.0.0 PKV"
  validate "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Krankenversicherungsverhaeltnis" \
           "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKVersicherungsverhaeltnisSelbstzahler" \
           "${TMP_DIR}/coverage/pkv"
  
  echo "[INFO] Perform FHIR coverage profile comparision of ISiK Basismodul 3.0.0 GKV vs. AWS 1.2.0"
  validate "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKVersicherungsverhaeltnisGesetzlich" \
           "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Krankenversicherungsverhaeltnis" \
           "${TMP_DIR}/coverage/gkv"

  echo "[INFO] Perform FHIR coverage profile comparision of ISiK Basismodul 3.0.0 PKV vs. AWS 1.2.0"
  validate "de.gematik.isik-basismodul" "3.0.0" "https://gematik.de/fhir/isik/v3/Basismodul/StructureDefinition/ISiKVersicherungsverhaeltnisSelbstzahler" \
           "kbv.ita.aws" "1.2.0" "https://fhir.kbv.de/StructureDefinition/KBV_PR_AW_Krankenversicherungsverhaeltnis" \
           "${TMP_DIR}/coverage/pkv"
}

function download() {
  local OUTPUT=${1}
  local URL=${2}
  local MSG=${3}

  [ ! -f ${OUTPUT} ] && echo ${MSG} && curl -s -L -o ${OUTPUT} ${URL}
}

echo "[INFO] Perform FHIR profile comparision of Check installed CLI tools"
[ -z "$(which java)" ] && echo "[ERROR] Require java runtime environment to perform compatibility checks (please install JRE)"

echo "[INFO] Perform FHIR profile comparision of Create output dir and perform profile comparision"
[ ! -d ${OUTPUT_DIR} ] && mkdir -p ${OUTPUT_DIR}
[ ! -d ${OUTPUT_DIR}/patient ] && compare_patient_profiles && mv ${TMP_DIR} ${OUTPUT_DIR}/patient
[ ! -d ${OUTPUT_DIR}/diagnose ] && compare_diagnose_profiles && mv ${TMP_DIR} ${OUTPUT_DIR}/diagnose
[ ! -d ${OUTPUT_DIR}/coverage ] && compare_coverage_profiles && mv ${TMP_DIR}/coverage ${OUTPUT_DIR}

