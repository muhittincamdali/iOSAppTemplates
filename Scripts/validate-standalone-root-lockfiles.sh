#!/bin/bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

require_pattern() {
  local pattern="$1"
  local file_path="$2"
  local error_message="$3"

  if ! grep -Eq "${pattern}" "${file_path}"; then
    echo "${error_message}" >&2
    exit 1
  fi
}

roots_without_external_dependencies=(
  "Templates/EcommerceApp"
  "Templates/NewsBlogApp"
  "Templates/MusicPodcastApp"
  "Templates/MarketplaceApp"
  "Templates/MessagingApp"
  "Templates/BookingReservationsApp"
  "Templates/NotesKnowledgeApp"
  "Templates/CreatorShortVideoApp"
  "Templates/TeamCollaborationApp"
  "Templates/CRMAdminApp"
  "Templates/SubscriptionLifestyleApp"
  "Templates/PrivacyVaultApp"
)

roots_with_lockfiles=(
  "Templates/SocialMediaApp"
  "Templates/FitnessApp"
  "Templates/ProductivityApp"
  "Templates/FinanceApp"
  "Templates/EducationApp"
  "Templates/FoodDeliveryApp"
  "Templates/TravelPlannerApp"
  "Templates/AIAssistantApp"
)

required_doc_paths=(
  "Documentation/App-Proofs/EcommerceApp.md"
  "Documentation/App-Proofs/SocialMediaApp.md"
  "Documentation/App-Proofs/FitnessApp.md"
  "Documentation/App-Proofs/ProductivityApp.md"
  "Documentation/App-Proofs/FinanceApp.md"
  "Documentation/App-Proofs/EducationApp.md"
  "Documentation/App-Proofs/FoodDeliveryApp.md"
  "Documentation/App-Proofs/TravelPlannerApp.md"
  "Documentation/App-Proofs/AIAssistantApp.md"
  "Documentation/App-Proofs/NewsBlogApp.md"
  "Documentation/App-Proofs/MusicPodcastApp.md"
  "Documentation/App-Proofs/MarketplaceApp.md"
  "Documentation/App-Proofs/MessagingApp.md"
  "Documentation/App-Proofs/BookingReservationsApp.md"
  "Documentation/App-Proofs/NotesKnowledgeApp.md"
  "Documentation/App-Proofs/CreatorShortVideoApp.md"
  "Documentation/App-Proofs/TeamCollaborationApp.md"
  "Documentation/App-Proofs/CRMAdminApp.md"
  "Documentation/App-Proofs/SubscriptionLifestyleApp.md"
  "Documentation/App-Proofs/PrivacyVaultApp.md"
  "Templates/EcommerceApp/README.md"
  "Templates/SocialMediaApp/README.md"
  "Templates/FitnessApp/README.md"
  "Templates/ProductivityApp/README.md"
  "Templates/FinanceApp/README.md"
  "Templates/EducationApp/README.md"
  "Templates/FoodDeliveryApp/README.md"
  "Templates/TravelPlannerApp/README.md"
  "Templates/AIAssistantApp/README.md"
  "Templates/NewsBlogApp/README.md"
  "Templates/MusicPodcastApp/README.md"
  "Templates/MarketplaceApp/README.md"
  "Templates/MessagingApp/README.md"
  "Templates/BookingReservationsApp/README.md"
  "Templates/NotesKnowledgeApp/README.md"
  "Templates/CreatorShortVideoApp/README.md"
  "Templates/TeamCollaborationApp/README.md"
  "Templates/CRMAdminApp/README.md"
  "Templates/SubscriptionLifestyleApp/README.md"
  "Templates/PrivacyVaultApp/README.md"
  "Documentation/Proof-Matrix.md"
  "Documentation/Template-Showcase.md"
)

for root in "${roots_without_external_dependencies[@]}"; do
  package_file="${repo_root}/${root}/Package.swift"
  resolved_file="${repo_root}/${root}/Package.resolved"

  if [[ ! -f "${package_file}" ]]; then
    echo "Missing package manifest: ${root}/Package.swift" >&2
    exit 1
  fi

  if [[ -f "${resolved_file}" ]]; then
    echo "Unexpected lockfile: ${root}/Package.resolved" >&2
    exit 1
  fi
done

for root in "${roots_with_lockfiles[@]}"; do
  package_file="${repo_root}/${root}/Package.swift"
  resolved_file="${repo_root}/${root}/Package.resolved"

  if [[ ! -f "${package_file}" ]]; then
    echo "Missing package manifest: ${root}/Package.swift" >&2
    exit 1
  fi

  if [[ ! -f "${resolved_file}" ]]; then
    echo "Missing lockfile: ${root}/Package.resolved" >&2
    exit 1
  fi

  python3 - "${resolved_file}" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
with path.open("r", encoding="utf-8") as handle:
    payload = json.load(handle)

pins = payload.get("pins")
if not isinstance(pins, list) or not pins:
    raise SystemExit(f"Lockfile has no pins: {path}")
PY
done

for relative_path in "${required_doc_paths[@]}"; do
  file_path="${repo_root}/${relative_path}"

  if [[ ! -f "${file_path}" ]]; then
    echo "Missing documentation surface: ${relative_path}" >&2
    exit 1
  fi
done

require_pattern 'Templates/EcommerceApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention EcommerceApp dependency-free proof."
require_pattern 'Templates/NewsBlogApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention NewsBlogApp dependency-free proof."
require_pattern 'Templates/MusicPodcastApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention MusicPodcastApp dependency-free proof."
require_pattern 'Templates/MarketplaceApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention MarketplaceApp dependency-free proof."
require_pattern 'Templates/MessagingApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention MessagingApp dependency-free proof."
require_pattern 'Templates/BookingReservationsApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention BookingReservationsApp dependency-free proof."
require_pattern 'Templates/NotesKnowledgeApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention NotesKnowledgeApp dependency-free proof."
require_pattern 'Templates/CreatorShortVideoApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention CreatorShortVideoApp dependency-free proof."
require_pattern 'Templates/TeamCollaborationApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention TeamCollaborationApp dependency-free proof."
require_pattern 'Templates/CRMAdminApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention CRMAdminApp dependency-free proof."
require_pattern 'Templates/SubscriptionLifestyleApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention SubscriptionLifestyleApp dependency-free proof."
require_pattern 'Templates/PrivacyVaultApp/Package\.swift.*no external dependency lockfile is required' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention PrivacyVaultApp dependency-free proof."
require_pattern 'Templates/SocialMediaApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention SocialMediaApp lockfile coverage."
require_pattern 'Templates/FitnessApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention FitnessApp lockfile coverage."
require_pattern 'Templates/ProductivityApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention ProductivityApp lockfile coverage."
require_pattern 'Templates/FinanceApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention FinanceApp lockfile coverage."
require_pattern 'Templates/EducationApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention EducationApp lockfile coverage."
require_pattern 'Templates/FoodDeliveryApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention FoodDeliveryApp lockfile coverage."
require_pattern 'Templates/TravelPlannerApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention TravelPlannerApp lockfile coverage."
require_pattern 'Templates/AIAssistantApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention AIAssistantApp lockfile coverage."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/EcommerceApp.md" "EcommerceApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/NewsBlogApp.md" "NewsBlogApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/MusicPodcastApp.md" "MusicPodcastApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/MarketplaceApp.md" "MarketplaceApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/MessagingApp.md" "MessagingApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/BookingReservationsApp.md" "BookingReservationsApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/NotesKnowledgeApp.md" "NotesKnowledgeApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/CreatorShortVideoApp.md" "CreatorShortVideoApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/TeamCollaborationApp.md" "TeamCollaborationApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/CRMAdminApp.md" "CRMAdminApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/SubscriptionLifestyleApp.md" "SubscriptionLifestyleApp proof surface must mention the dependency-free graph."
require_pattern 'no external dependency lockfile is required' "${repo_root}/Documentation/App-Proofs/PrivacyVaultApp.md" "PrivacyVaultApp proof surface must mention the dependency-free graph."
require_pattern 'Templates/SocialMediaApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/SocialMediaApp.md" "SocialMediaApp proof surface must mention the lockfile."
require_pattern 'Templates/FitnessApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/FitnessApp.md" "FitnessApp proof surface must mention the lockfile."
require_pattern 'Templates/ProductivityApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/ProductivityApp.md" "ProductivityApp proof surface must mention the lockfile."
require_pattern 'Templates/FinanceApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/FinanceApp.md" "FinanceApp proof surface must mention the lockfile."
require_pattern 'Templates/EducationApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/EducationApp.md" "EducationApp proof surface must mention the lockfile."
require_pattern 'Templates/FoodDeliveryApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/FoodDeliveryApp.md" "FoodDeliveryApp proof surface must mention the lockfile."
require_pattern 'Templates/TravelPlannerApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/TravelPlannerApp.md" "TravelPlannerApp proof surface must mention the lockfile."
require_pattern 'Templates/AIAssistantApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/AIAssistantApp.md" "AIAssistantApp proof surface must mention the lockfile."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/EcommerceApp/README.md" "EcommerceApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/NewsBlogApp/README.md" "NewsBlogApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/MusicPodcastApp/README.md" "MusicPodcastApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/MarketplaceApp/README.md" "MarketplaceApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/MessagingApp/README.md" "MessagingApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/BookingReservationsApp/README.md" "BookingReservationsApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/NotesKnowledgeApp/README.md" "NotesKnowledgeApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/CreatorShortVideoApp/README.md" "CreatorShortVideoApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/TeamCollaborationApp/README.md" "TeamCollaborationApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/CRMAdminApp/README.md" "CRMAdminApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/SubscriptionLifestyleApp/README.md" "SubscriptionLifestyleApp template README must mention the dependency-free graph."
require_pattern 'No external dependency lockfile is required today' "${repo_root}/Templates/PrivacyVaultApp/README.md" "PrivacyVaultApp template README must mention the dependency-free graph."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/SocialMediaApp/README.md" "SocialMediaApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/FitnessApp/README.md" "FitnessApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/ProductivityApp/README.md" "ProductivityApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/FinanceApp/README.md" "FinanceApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/EducationApp/README.md" "EducationApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/FoodDeliveryApp/README.md" "FoodDeliveryApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/TravelPlannerApp/README.md" "TravelPlannerApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/AIAssistantApp/README.md" "AIAssistantApp template README must mention the lockfile."

echo "Standalone root lockfile surfaces look good."
