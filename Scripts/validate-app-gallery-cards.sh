#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

gallery_doc="Documentation/App-Gallery.md"
assets_dir="Documentation/Assets/AppCards"

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

[[ -f "$gallery_doc" ]] || { echo "Missing gallery doc: $gallery_doc" >&2; exit 1; }
[[ -d "$assets_dir" ]] || { echo "Missing gallery asset directory: $assets_dir" >&2; exit 1; }

for app in "${apps[@]}"; do
  asset="$assets_dir/${app}.svg"
  media_doc="Documentation/App-Media/${app}.md"

  [[ -f "$asset" ]] || { echo "Missing gallery asset: $asset" >&2; exit 1; }
  [[ -f "$media_doc" ]] || { echo "Missing media doc: $media_doc" >&2; exit 1; }

  grep -Fq "${app}.svg" "$gallery_doc" || { echo "$gallery_doc missing asset link for $app" >&2; exit 1; }
  grep -Fq "${app}.svg" "$media_doc" || { echo "$media_doc missing asset link for $app" >&2; exit 1; }
  grep -Fq 'Media status: `card-published`' "$media_doc" || { echo "$media_doc missing card-published status" >&2; exit 1; }
done

echo "App gallery cards validation passed."
