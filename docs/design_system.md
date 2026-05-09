# MyoTwin Design System

## Overview

A black-and-white cyberpunk/sci-fi aesthetic with glitch aesthetics, HUD-style layout, terminal-inspired typography, and holographic window transitions.

**Inspiration**: Deus Ex HUD interfaces, Ghost in the Shell holographic displays, Cyberpunk 2077 navigation, Glitch/signal distortion effects, CRT terminal interfaces, system diagnostic screens.

**Core Principle**: Everything reads like a military or experimental system interface. Clean lines, sharp contrast, monochrome depth with deliberate accent colors only for data visualization (heatmap, error states, warnings).

---

## Design Tokens

### Palette

| Token | Hex | Usage |
|---|---|---|
| `surface` | `#0A0A0A` | Primary background |
| `surface-elevated` | `#111111` | Cards, bottom sheets |
| `surface-elevated-2` | `#1A1A1A` | Modal backgrounds |
| `surface-elevated-3` | `#222222` | Dialogs, FAB rest state |
| `outline` | `#2A2A2A` | Borders, dividers, inactive strokes |
| `outline-dim` | `#1F1F1F` | Disabled borders, subtle separators |
| `inset` | `#000000` | Inner shadows, pressed states |
| `on-surface` | `#E0E0E0` | Primary text, active icons |
| `on-surface-medium` | `#999999` | Secondary text, disabled |
| `on-surface-dim` | `#666666` | Tertiary text, placeholder |
| `white` | `#FFFFFF` | Pure white accent (HUD highlights) |
| `black` | `#000000` | Pure black for clipping/glitch |

| Data Accent | Hex | Usage |
|---|---|---|
| `accent` | `#A0A0A0` | Primary action fill, FAB active |
| `accent-hot` | `#C8C8C8` | FAB hot/active, focus ring |
| `heat-low` | `#556060` | Low intensity heatmap (teal-gray) |
| `heat-med` | `#4A5A4A` | Medium intensity heatmap |
| `heat-high` | `#604030` | High intensity heatmap |
| `heat-critical` | `#703030` | Critical / error heatmap |
| `link-faint` | `#3A5A4A` | Uncertain kinetic chains |
| `link-strong` | `#6A8A7A` | Proven kinetic chains |
| `success` | `#607060` | Positive feedback |
| `error` | `#803030` | Error states, critical warnings |

---

### Typography

| Token | Font | Size | Weight | Letter-Space | Usage |
|---|---|---|---|---|---|
| `display-large` | `Space Mono` | `32px` | `700` | `-2%` | Hero numbers (reps, scores) |
| `display-medium` | `Space Mono` | `24px` | `700` | `-1%` | Section headers |
| `headline-large` | `Space Mono` | `20px` | `600` | `-1%` | Dialog titles |
| `headline-medium` | `Space Mono` | `16px` | `600` | `0%` | Card titles |
| `title` | `Space Mono` | `14px` | `600` | `0%` | Tab labels |
| `body-large` | `Space Mono` | `16px` | `400` | `-1%` | Chat messages, long text |
| `body-medium` | `Space Mono` | `14px` | `400` | `-1%` | Descriptions |
| `body-small` | `Space Mono` | `12px` | `400` | `0%` | Metadata, timestamps |
| `caption` | `Space Mono` | `11px` | `400` | `0%` | Labels, tags |
| `overline` | `Space Mono` | `10px` | `600` | `3%` uppercase | Section separators |
| `terminal` | `JetBrains Mono` | `14px` | `400` | `-2%` | Agent responses, code blocks |
| `glitch` | `JetBrains Mono` | `14px` | `700` | `-2%` | System warnings, boot screens |

**Fallback**: `Courier New` → `Menlo` → `monospace`

---

### Shape & Elevation

| Token | Value | Usage |
|---|---|---|
| `radius-none` | `0px` | Body map segments, HUD panels |
| `radius-sm` | `4px` | FAB rest, small buttons |
| `radius-md` | `8px` | Elevated cards, bottom sheet grabber |
| `radius-lg` | `16px` | Dialogs, chat bubbles (agent) |
| `radius-full` | `999px` | FAB active/hot state |
| `elevation-0` | `none` | All surfaces default, no shadow |
| `elevation-1` | `0px 1px 0px rgba(255,255,255,0.08)` | FAB elevated, FAB pressed |
| `elevation-2` | `0px 2px 4px rgba(0,0,0,0.6), inset 0 1px 0 rgba(255,255,255,0.05)` | Modal backgrounds |
| `elevation-glow` | `0px 0px 12px rgba(160,160,160,0.15)` | FAB hot, active elements |

**Key Rule**: This is a **no-elevation** design. Surfaces are distinguished by surface level contrast, not shadow. The only "glow" is the hot state of interactive elements.

---

### Motion & Duration

| Token | Duration | Curve | Usage |
|---|---|---|---|
| `motion-fast` | `80ms` | `decelerate` | Checkbox, icon toggle |
| `motion-normal` | `250ms` | `ease-out` | FAB morph hover |
| `motion-slow` | `400ms` | `ease-in-out` | Bottom sheet slide up |
| `motion-slower` | `600ms` | `decelerate` | Hot/cold FAB state change |
| `motion-glitch` | `120ms` | `step-end` | Window open/close, boot screen |
| `motion-holographic` | `500ms` | `ease-out` | Scene transitions (scan-in effect) |
| `motion-feedback` | `60ms` | `ease-out` | Haptic response animation |

| Motion Type | Parameter | Usage |
|---|---|---|
| FAB rest → hot | `scale(1.0 → 1.2)` + `rotate(0deg → 8deg)` | Press or long-press |
| FAB hot → locked | `scale(1.2 → 1.35)` + `color shift` | Slide-to-lock |
| Bottom sheet open | `translateY(100%) → 0%` + `scan-line reveal` | Chat sheet slide up |
| Section transition | `clip mask scan vertically left-to-right` | Dossier, FAB |
| Window open | `step-end glitch` → `holographic fan-in` | Any major view entry |
| FAB pulse (hot) | `elevation-glow` loop 3x/sec | Mic hot state |
| Error state | `translateX 10px` x3, `opacity 0.7` | Shake animation |

---

### Animation Patterns (Cyberpunk HUD Style)

#### 1. **Scan-In Reveal**
Used for bottom sheets, panel entrances. Content reveals left-to-right with a thin white line (1px, `#FFFFFF` at 12% opacity) scanning across the surface.

#### 2. **Glitch Flicker**
Used for window transitions, boot screens, error states. Frame-by-frame displacement: shift pixels horizontally ±2px in alternating directions for 3 frames, then restore.

#### 3. **Holographic Fade**
Used for scene transitions between views. Content appears to "materialize" from scan-lines: vertical bars at 40% opacity progressively fade in, creating a CRT boot-up effect.

#### 4. **Signal Pulse**
Used for FAB hot state and active indicators. A circular ring expands from center at 3x per second, fading to 0 opacity.

#### 5. **Data Stream**
Used for chat message arrival. Text appears character-by-character (monospace font makes this feel like terminal output). Speed: 30ms per character.

#### 6. **Heat Map Interpolation**
Heatmap colors transition with a 200ms ease-in. Colors shift on a per-vertex basis, creating a "thermal bloom" effect.

#### 7. **Kinetic Chain Draw**
Chains on the body map draw themselves as a dashed line (stroke-dasharray: `4 2`) from source to target node over 1.5 seconds. Opacity scales with certainty.

#### 8. **Terminal Typing**
Agent responses rendered as terminal input. Each character appears with a subtle cursor blink (`0.5s` interval). Long responses (>50 chars) start appearing after a 150ms "processing" delay to simulate computation.

#### 9. **Overlay Dismiss**
FAB dismisses with `scale(1.2 → 0.85)` + `opacity(1 → 0)` in 120ms. Creates a "collapse" or "shrink away" effect reminiscent of holographic display powering off.

---

## Widget Implementation Guide

### Button

| State | Surface | Outline | Color | Elevation |
|---|---|---|---|---|
| Default | `#1A1A1A` | `#2A2A2A` | `#E0E0E0` | none |
| Hover | `#222222` | `#4A4A4A` | `#FFFFFF` | `elevation-1` |
| Pressed | `#111111` | `#2A2A2A` | `#A0A0A0` | none |
| Disabled | `#0A0A0A` | `#1F1F1F` | `#333333` | none |

### FAB

| State | Radius | Scale | Color | Glow |
|---|---|---|---|---|
| Rest | `radius-sm` | 1.0 | `#222222` | none |
| Hover | `radius-sm` | 1.05 | `#2A2A2A` | none |
| Active/Holding | `radius-full` | 1.15 | `#A0A0A0` | `elevation-glow` pulse |
| Hot | `radius-full` | 1.25 | `#C8C8C8` | `elevation-glow` pulse 3Hz |
| Locked Hot | `radius-full` | 1.35 | `#E0E0E0` | `elevation-glow` pulse 6Hz |

### Chat Bubble

| Role | Surface | Outline | Corner Radius |
|---|---|---|---|
| User | `#1A1A1A` | `#4A4A4A` | `radius-lg` (right) + `radius-sm` (left tail) |
| Agent | `#0A0A0A` | `#2A2A2A` | `radius-lg` (left) + `radius-sm` (right tail) |

Agent messages rendered with `terminal` font token. Typing indicator uses the `signal pulse` pattern.

### Heatmap Body Map

| Intensity | Color (vertex emissive) | Opacity |
|---|---|---|
| 0.0 | `#0A0A0A` | 0.0 |
| 0.25 | `#3A4A4A` | 0.3 |
| 0.50 | `#4A5A4A` | 0.5 |
| 0.75 | `#604030` | 0.7 |
| 1.0 | `#703030` | 0.95 |

### Kinetic Chain Line

| Certainty | Color | Stroke Width | Dash Pattern |
|---|---|---|---|
| 0.0 - 0.25 | `#3A5A4A` | `1px` | `2 4` (faint) |
| 0.25 - 0.50 | `#4A7A5A` | `2px` | `3 4` |
| 0.50 - 0.75 | `#6A8A7A` | `3px` | `4 4` |
| 0.75 - 1.0 | `#8ABA8A` | `4px` | none (solid) |

### Navigation Drawer / Panels

| Layer | Surface | Outline |
|---|---|---|
| Background | `#0A0A0A` | none |
| Drawer | `#111111` | `1px #2A2A2A solid` right edge only |
| Active Item | `2px` left accent bar | `#C8C8C8` |
| Inactive Item | `none` | none |

### Dialog

| Layer | Surface | Outline | Radius |
|---|---|---|---|
| Surface | `#1A1A1A` | `1px #2A2A2A solid` | `radius-lg` |
| Backdrop | `rgba(0,0,0,0.85)` | none | none |
| Entrance | Scan-in + holographic fade | `600ms` holographic | |

---

## Asset References

### Fonts (Google Fonts — self-hosted)
- **Space Mono**: `400, 600, 700` — primary typeface for all UI
- **JetBrains Mono**: `400, 700` — terminal output, system messages

### SVG Patterns
- `grid-background.svg`: 24x24 subtle grid pattern (`#1A1A1A` on `#0A0A0A`)
- `scanlines.svg`: Horizontal lines, 1px every 3px at 4% white opacity
- `noise-overlay.svg`: Subtle SVG noise filter for CRT texture

### Icons
- Use [Lucide Icons](https://lucide.dev/icons) — monoline, geometric, fits the terminal/HUD aesthetic.
- Stroke width: `1.5px`
- Color: `#E0E0E0` default, `#C8C8C8` active, `#666666` disabled

---

## Dark Mode

The design system is **dark-only** by default. There is no light mode toggle — the entire system is built for a low-light, terminal/HUD aesthetic.

---

## Accessibility Notes

| Contrast | Minimum Ratio |
|---|---|
| Primary text on surface | `12.5:1` (`#E0E0E0` on `#0A0A0A`) |
| Secondary text on surface | `4.6:1` (`#999999` on `#0A0A0A`) — passes WCAG AA |
| Accent text on surface | `11.8:1` (`#C8C8C8` on `#0A0A0A`) |
| Error text on surface | `5.2:1` (`#803030` on `#0A0A0A`) — use bold for critical |

Always use **bold** (weight 600+) for error/critical content to compensate for reduced contrast ratios on low-intensity heatmap colors.

---

**Document version**: 1.0
**Last updated**: 2026-05-09
