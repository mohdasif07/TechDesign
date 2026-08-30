Arqvexa Brand Assets
====================

Use these files for website, Google Business, social media, and print.

LOGO FILES (in /public/)
------------------------
logo.svg              Full logo (dark text) — website, documents
logo-white.svg        Full logo (white text) — dark backgrounds
logo-mark.svg         Icon only — navigation, favicon source
icon.svg              App icon source (512px)

SHARE / SOCIAL (in /public/brand/)
----------------------------------
logo-share-square.svg   1080×1080 — Instagram, LinkedIn, WhatsApp status
logo-share-square.png   PNG export (generate below)

PNG EXPORTS (run from project root)
-----------------------------------
convert -background none public/logo-mark.svg -resize 512x512 public/logo-mark.png
convert -background none public/logo.svg -resize 1200x294 public/logo.png
convert -background none public/logo-white.svg -resize 1200x294 public/logo-white.png
convert -background none public/icon.svg -resize 512x512 public/icon.png
convert -background none public/icon.svg -resize 192x192 public/icon-192.png
convert -background none public/brand/logo-share-square.svg -resize 1080x1080 public/brand/logo-share-square.png

COLORS
------
Navy:   #0b1930
Orange: #e87935
Accent: #ffb07a

WEBSITE: https://arqvexa.in
