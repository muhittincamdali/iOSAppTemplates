#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

apps=(
  "EcommerceApp"
  "SocialMediaApp"
  "FitnessApp"
  "ProductivityApp"
  "FinanceApp"
  "EducationApp"
  "FoodDeliveryApp"
  "TravelPlannerApp"
  "AIAssistantApp"
  "NewsBlogApp"
  "MusicPodcastApp"
  "MarketplaceApp"
  "MessagingApp"
  "BookingReservationsApp"
  "NotesKnowledgeApp"
  "CreatorShortVideoApp"
  "TeamCollaborationApp"
  "CRMAdminApp"
  "SubscriptionLifestyleApp"
  "PrivacyVaultApp"
)

for app in "${apps[@]}"; do
  preview="Documentation/Assets/AppPreviews/${app}.svg"
  media="Documentation/App-Media/${app}.md"
  gallery="Documentation/App-Gallery.md"

  [[ -f "$preview" ]] || { echo "Missing preview board: $preview" >&2; exit 1; }
  grep -Fq "${app}.svg" "$gallery" || { echo "$gallery missing preview reference for $app" >&2; exit 1; }
  grep -Fq "../Assets/AppPreviews/${app}.svg" "$media" || { echo "$media missing preview reference for $app" >&2; exit 1; }
  grep -Fq 'preview board is published' "$media" || { echo "$media missing preview board truth" >&2; exit 1; }
done

echo "App preview boards validation passed."
