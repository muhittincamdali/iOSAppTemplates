#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

gallery_doc="Documentation/App-Gallery.md"
assets_dir="Documentation/Assets/AppCards"
screenshots_dir="Documentation/Assets/AppScreenshots"

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
  screenshot_asset="$screenshots_dir/${app}.png"

  [[ -f "$asset" ]] || { echo "Missing gallery asset: $asset" >&2; exit 1; }
  [[ -f "$media_doc" ]] || { echo "Missing media doc: $media_doc" >&2; exit 1; }

  grep -Fq "${app}.svg" "$gallery_doc" || { echo "$gallery_doc missing asset link for $app" >&2; exit 1; }
  grep -Fq "${app}.svg" "$media_doc" || { echo "$media_doc missing asset link for $app" >&2; exit 1; }

  if [[ -f "$screenshot_asset" ]]; then
    grep -Fq "${app}.png" "$gallery_doc" || { echo "$gallery_doc missing screenshot link for $app" >&2; exit 1; }
    if grep -Fq 'Media status: `demo-published`' "$media_doc"; then
      :
    else
      grep -Fq 'Media status: `screenshot-published`' "$media_doc" || { echo "$media_doc missing screenshot-published or demo-published status" >&2; exit 1; }
    fi
  else
    grep -Fq 'Media status: `preview-published`' "$media_doc" || { echo "$media_doc missing preview-published status" >&2; exit 1; }
  fi
done

echo "App gallery cards validation passed."
