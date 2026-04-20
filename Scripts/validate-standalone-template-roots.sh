#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

ROOTS=(
  "Templates/EcommerceApp:EcommerceApp"
  "Templates/SocialMediaApp:SocialMediaApp"
  "Templates/FitnessApp:FitnessApp"
  "Templates/ProductivityApp:ProductivityApp"
  "Templates/FinanceApp:FinanceApp"
  "Templates/EducationApp:EducationApp"
  "Templates/FoodDeliveryApp:FoodDeliveryApp"
  "Templates/TravelPlannerApp:TravelPlannerApp"
  "Templates/AIAssistantApp:AIAssistantApp"
  "Templates/NewsBlogApp:NewsBlogApp"
  "Templates/MusicPodcastApp:MusicPodcastApp"
  "Templates/MarketplaceApp:MarketplaceApp"
  "Templates/MessagingApp:MessagingApp"
  "Templates/BookingReservationsApp:BookingReservationsApp"
  "Templates/NotesKnowledgeApp:NotesKnowledgeApp"
  "Templates/CreatorShortVideoApp:CreatorShortVideoApp"
  "Templates/TeamCollaborationApp:TeamCollaborationApp"
)

assert_exists() {
  local path="$1"

  if [[ ! -e "$path" ]]; then
    echo "Missing required standalone root surface: $path" >&2
    exit 1
  fi
}

assert_swift_file_present() {
  local directory="$1"

  if ! find "$directory" -maxdepth 1 -type f -name '*.swift' | grep -q .; then
    echo "Expected at least one Swift file in: $directory" >&2
    exit 1
  fi
}

for entry in "${ROOTS[@]}"; do
  IFS=":" read -r root name <<<"$entry"

  echo "Validating standalone root: $name"

  assert_exists "$root/Package.swift"
  assert_exists "$root/Sources/$name"
  assert_exists "$root/Sources/${name}UI"
  assert_exists "$root/Sources/${name}Core"
  assert_exists "$root/Tests/${name}Tests"

  assert_swift_file_present "$root/Sources/$name"
  assert_swift_file_present "$root/Sources/${name}UI"
  assert_swift_file_present "$root/Sources/${name}Core"
  assert_swift_file_present "$root/Tests/${name}Tests"

  swift package dump-package --package-path "$root" >/dev/null
done
