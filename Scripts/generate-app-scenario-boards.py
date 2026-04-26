#!/usr/bin/env python3

from __future__ import annotations

import json
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
CATALOG_PATH = REPO_ROOT / "Documentation" / "app-surface-catalog.json"
OUTPUT_DIR = REPO_ROOT / "Documentation" / "Assets" / "AppScenarioBoards"

PALETTE = {
    "Commerce": ("#FF7A18", "#FFB347"),
    "Social": ("#0061FF", "#60EFFF"),
    "Health / Fitness": ("#11998E", "#38EF7D"),
    "Productivity": ("#3A1C71", "#D76D77"),
    "Finance": ("#134E5E", "#71B280"),
    "Education": ("#4E54C8", "#8F94FB"),
    "Food Delivery": ("#CB2D3E", "#EF473A"),
    "Travel": ("#2BC0E4", "#EAECC6"),
    "AI": ("#141E30", "#243B55"),
    "News": ("#355C7D", "#C06C84"),
    "Music / Podcast": ("#DA4453", "#89216B"),
    "Marketplace": ("#283048", "#859398"),
    "Messaging / Community": ("#1D976C", "#93F9B9"),
    "Booking / Reservations": ("#4B79A1", "#283E51"),
    "Notes / Knowledge": ("#F7971E", "#FFD200"),
    "Creator / Short Video": ("#654EA3", "#EAafc8"),
    "Team Collaboration": ("#0F2027", "#2C5364"),
    "CRM / Admin": ("#7F00FF", "#E100FF"),
    "Subscription Lifestyle": ("#F953C6", "#B91D73"),
    "Privacy / Secure Vault": ("#232526", "#414345"),
}


def escape(value: str) -> str:
    return (
        value.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
    )


def load_catalog() -> list[dict[str, object]]:
    return json.loads(CATALOG_PATH.read_text())


def board_svg(app: dict[str, object]) -> str:
    app_id = str(app["app"])
    lane = str(app["lane"])
    focus_a, focus_b, focus_c = [escape(str(item)) for item in app["capture_targets"]]
    accent_start, accent_end = PALETTE.get(lane, ("#1F2937", "#6B7280"))
    return f"""<svg width="1800" height="1160" viewBox="0 0 1800 1160" fill="none" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bg" x1="100" y1="70" x2="1680" y2="1080" gradientUnits="userSpaceOnUse">
      <stop stop-color="{accent_start}"/>
      <stop offset="1" stop-color="{accent_end}"/>
    </linearGradient>
    <linearGradient id="panel" x1="118" y1="118" x2="1690" y2="1050" gradientUnits="userSpaceOnUse">
      <stop stop-color="#020617" stop-opacity="0.95"/>
      <stop offset="1" stop-color="#111827" stop-opacity="0.88"/>
    </linearGradient>
  </defs>
  <rect width="1800" height="1160" fill="#020617"/>
  <rect x="32" y="32" width="1736" height="1096" rx="44" fill="url(#bg)"/>
  <rect x="84" y="84" width="1632" height="992" rx="38" fill="url(#panel)"/>
  <rect x="130" y="132" width="290" height="46" rx="23" fill="white" fill-opacity="0.12"/>
  <text x="162" y="162" fill="#E5E7EB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">runtime scenario board</text>
  <text x="130" y="278" fill="white" font-size="68" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="800">{escape(app_id)}</text>
  <text x="130" y="330" fill="#D1D5DB" font-size="30" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="600">{escape(lane)}</text>
  <text x="130" y="406" fill="#F8FAFC" font-size="26" font-family="SF Pro Display, Helvetica, Arial, sans-serif">Published runtime progression: launch, ready, and first-screen proof.</text>
  <text x="130" y="448" fill="#D1D5DB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif">This is a canonical proof board, not a complete-app parity claim.</text>
  <rect x="130" y="520" width="424" height="86" rx="24" fill="white" fill-opacity="0.10"/>
  <text x="164" y="575" fill="white" font-size="28" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">Launch-to-ready proof published</text>
  <text x="130" y="672" fill="#E5E7EB" font-size="22" font-family="SF Pro Display, Helvetica, Arial, sans-serif">Capture targets:</text>
  <text x="130" y="716" fill="#F8FAFC" font-size="22" font-family="SF Pro Display, Helvetica, Arial, sans-serif">1. {focus_a}</text>
  <text x="130" y="754" fill="#F8FAFC" font-size="22" font-family="SF Pro Display, Helvetica, Arial, sans-serif">2. {focus_b}</text>
  <text x="130" y="792" fill="#F8FAFC" font-size="22" font-family="SF Pro Display, Helvetica, Arial, sans-serif">3. {focus_c}</text>

  <text x="700" y="160" fill="#E5E7EB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">launch</text>
  <rect x="700" y="184" width="310" height="640" rx="34" fill="white" fill-opacity="0.08"/>
  <image href="../AppScenarioShots/{escape(app_id)}-launch.png" x="724" y="208" width="262" height="592" preserveAspectRatio="xMidYMid slice"/>

  <text x="1048" y="160" fill="#E5E7EB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">ready</text>
  <rect x="1048" y="184" width="310" height="640" rx="34" fill="white" fill-opacity="0.08"/>
  <image href="../AppScenarioShots/{escape(app_id)}-ready.png" x="1072" y="208" width="262" height="592" preserveAspectRatio="xMidYMid slice"/>

  <text x="1396" y="160" fill="#E5E7EB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">first-screen</text>
  <rect x="1396" y="184" width="310" height="640" rx="34" fill="white" fill-opacity="0.08"/>
  <image href="../AppScreenshots/{escape(app_id)}.png" x="1420" y="208" width="262" height="592" preserveAspectRatio="xMidYMid slice"/>

  <rect x="700" y="864" width="1006" height="132" rx="28" fill="white" fill-opacity="0.08"/>
  <text x="736" y="920" fill="#F8FAFC" font-size="28" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">Runtime proof board</text>
  <text x="736" y="960" fill="#D1D5DB" font-size="22" font-family="SF Pro Display, Helvetica, Arial, sans-serif">Use the scenario page, proof page, and media page together for the current truth.</text>
 </svg>
"""


def main() -> int:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    catalog = load_catalog()
    for app in catalog:
        output = OUTPUT_DIR / f"{app['app']}.svg"
        output.write_text(board_svg(app) + "\n")
    print(f"Generated {len(catalog)} scenario boards in {OUTPUT_DIR}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
