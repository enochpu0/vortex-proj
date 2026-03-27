# UI Design System Specification for Agent

> A comprehensive design system guide for generating consistent, modern user interfaces across web and mobile applications.

---

## Table of Contents

1. [Global Design Principles](#1-global-design-principles)
2. [Color Palette](#2-color-palette)
3. [Typography](#3-typography)
4. [Layout & Spacing](#4-layout--spacing)
5. [Core Components](#5-core-components)
6. [Scenario Templates](#6-scenario-templates)

---

## 1. Global Design Principles

### Style Positioning

| Attribute | Value |
|-----------|-------|
| **Design Style** | Modern Flat, Soft Neumorphism |
| **Border Radius** | High (Generous rounding) |
| **Layout Philosophy** | Card-based with whitespace separation |

### Visual Hierarchy

- **Card-based Layout**: Content blocks separated by whitespace and soft shadows, not harsh dividers
- **Elevation**: Use subtle shadows to create depth and hierarchy
- **Focus Points**: Primary actions and key information emphasized through color and size

### Interaction Feedback

| State | Effect |
|-------|--------|
| **Hover** | Color darkening or subtle scale (1.02-1.05) |
| **Active** | Noticeable color shift, slight press effect |
| **Focus** | Visible outline or glow for accessibility |

### Border Radius Strategy

| Element | Radius Value |
|---------|--------------|
| Cards / Containers | `16px - 24px` |
| Buttons / Input Fields | `12px` or Pill Shape (`999px`) |
| Icon Backgrounds | `8px - 12px` |

### Shadow Guidelines

```css
/* Light Shadow */
box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);

/* Floating Card Shadow */
box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
```

---

## 2. Color Palette

Select one of the following color schemes based on the application theme, or generate variations following the same principles.

### Scheme A: Modern Education/Tech (EduEra Style)

| Token | Value | Usage |
|-------|-------|-------|
| `--primary` | `#5D3FE6` | Sidebar, primary buttons, emphasis text |
| `--secondary` | `#FF7B47` | Notifications, badges, CTA buttons |
| `--background` | `#FDF3E0` | Overall background (Soft Peach/Cream) |
| `--surface` | `#FFFFFF` | Card background (or gradient images) |
| `--text-main` | `#1F1F1F` | Primary text |
| `--text-secondary` | `#8E8E93` | Secondary/muted text |

### Scheme B: Health/Medical/Fresh (Health & School Style)

| Token | Value | Usage |
|-------|-------|-------|
| `--primary` | `#2ECC71` | Primary buttons, completion state, active tabs |
| `--secondary` | `#FF9F43` / `#54A0FF` | Category tags (Soft Orange / Soft Blue) |
| `--background` | `#F7F9F7` / `#FFFFFF` | Overall background |
| `--surface` | `#FFFFFF` / `#F0FDF4` | Card background |
| `--text-main` | `#2D3436` | Primary text |
| `--text-secondary` | `#B2BEC3` | Secondary/muted text |

### Scheme C: Travel/Service/High Contrast (Car Rental Style)

| Token | Value | Usage |
|-------|-------|-------|
| `--primary` | `#FF4F38` | Primary buttons, map markers, emphasis |
| `--background` | `#FFFFFF` / `#F5F5F5` | Overall background |
| `--surface` | `#FFFFFF` | Card background (with soft shadows) |
| `--dark-element` | `#1A1A1A` | Credit cards, map overlays |
| `--text-main` | `#000000` | Primary text |
| `--text-secondary` | `#666666` | Secondary/muted text |

---

## 3. Typography

### Font Family

```css
font-family: 'Inter', 'Roboto', 'SF Pro Display', 'Poppins', sans-serif;
```

### Type Hierarchy

| Level | Size | Weight | Usage |
|-------|------|--------|-------|
| **H1** (Page Title) | `24px - 32px` | Bold (700) | Main page headers |
| **H2** (Section Title) | `18px - 22px` | Semi-Bold (600) | Section headers |
| **H3** (Card Title) | `16px - 18px` | Medium (500) | Card titles |
| **Body** | `14px - 16px` | Regular (400) | Main content text |
| **Caption/Label** | `12px` | Medium (500) | Labels, optional uppercase |

---

## 4. Layout & Spacing

### Grid System

| Platform | Configuration |
|----------|---------------|
| **Mobile** | Single column, 20px - 24px side margins |
| **Desktop (Dashboard)** | Left sidebar (250px - 280px), right content area |

### Spacing Scale (8px Grid)

Use the following values for consistent spacing:

```
8px, 16px, 24px, 32px, 48px
```

### Padding & Gap

| Element | Value |
|---------|-------|
| Card Padding | `20px - 24px` |
| Element Gap | `12px - 16px` |

---

## 5. Core Components

### 5.1 Card

**Description**: Primary content container.

| Property | Value |
|----------|-------|
| Background | White (`#FFFFFF`) |
| Border Radius | `20px` |
| Shadow | Soft, diffused shadow |

#### Variants

| Variant | Description | Example |
|---------|-------------|---------|
| **Image Card** | Top or background image with semi-transparent gradient overlay for text | Course cards |
| **List Card** | Left: icon/image, Center: text info, Right: arrow or action button | Daily review items |
| **Stat Card** | Colored background, large number, short label | Subject recommendations |

---

### 5.2 Button

#### Primary Button

```css
background: var(--primary);
color: #FFF;
border-radius: 12px; /* or 999px for pill shape */
font-weight: 600;
```

#### Secondary Button

- Outline style OR light background with primary color text

#### Icon Button

- Circular or rounded square background
- Used for floating actions or top toolbar

---

### 5.3 Navigation

#### Sidebar (Desktop)

- Vertical list layout
- Selected item highlighted with background block

#### Tab Bar (Mobile)

- Fixed at bottom
- Icon + Text combination
- Selected state changes color

#### Top Bar

- Search bar (rounded rectangle, light gray background)
- User avatar
- Notification icon

---

### 5.4 Forms & Inputs

| Property | Value |
|----------|-------|
| Background | `#F5F5F5` (Light gray) |
| Border | None or very thin |
| Border Radius | `12px` |
| Icons | Internal, left-aligned |

#### Toggle/Switch

- Green or primary color indicates "ON" state

---

### 5.5 List Item

**Structure**: Flexbox layout (Left - Center - Right)

| Position | Content |
|----------|---------|
| **Left** | Icon / Avatar |
| **Center** | Title + Subtitle (gray text) |
| **Right** | Chevron (`>`) or Status Badge |

#### Timeline Style

- Left: Time display (e.g., `11:35`)
- Right: Content card
- Center: Connecting line (optional)

---

## 6. Scenario Templates

### Template A: Learning/Course Dashboard

**Applicable**: Education platforms, SaaS backends

#### Structure

```
┌─────────────────────────────────────────────────────────┐
│ ┌─────────┐ ┌─────────────────────────────────────────┐ │
│ │         │ │  Top Bar: Search + User Profile         │ │
│ │ Sidebar │ ├─────────────────────────────────────────┤ │
│ │ (Dark/  │ │                                         │ │
│ │ Primary)│ │  Section: "Unfinished Courses"          │ │
│ │         │ │  ┌─────────┐ ┌─────────┐                │ │
│ │ - Logo  │ │  │ Card 1  │ │ Card 2  │  Grid (2 cols)│ │
│ │ - Menu  │ │  └─────────┘ └─────────┘  w/ progress  │ │
│ │ - Widget│ │                                         │ │
│ │         │ │  Section: "Live Lessons"                │ │
│ │         │ │  [Card] [Card] [Card] ← Horizontal scroll│ │
│ └─────────┘ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

#### Key Features

- **Unfinished Courses**: Grid layout (2 columns), large cards with progress/duration badges
- **Live Lessons**: Horizontal scroll list, small cards with "LIVE" red badge

---

### Template B: Personal Task/Health Management (Mobile)

**Applicable**: To-do lists, medication reminders, fitness plans

#### Structure

```
┌─────────────────────────────────┐
│ Header: Greeting + Illustration │
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │   Today's Plan (Hero Card)  │ │
│ │   Highlight background      │ │
│ │   Progress: 1 of 4 done     │ │
│ └─────────────────────────────┘ │
│                                 │
│ Daily Review (Vertical List)   │
│ ✓ Task 1 (completed)           │
│ ○ Task 2 (pending)             │
│ ○ Task 3 (pending)             │
│                                 │
│ ┌─────────────────────────────┐ │
│ │      FAB / Bottom Nav       │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

#### Form Page Variation

- Clear labels
- Step-by-step input (Amount, Duration)
- Large color block selectors (Food & Pills)

---

### Template C: Booking Flow

**Applicable**: Ride-sharing, car rental, hotel booking

#### Structure

```
┌─────────────────────────────────┐
│         Map View Background     │
│    ┌───────────────────────┐    │
│    │  Price/Vehicle Overlay│    │
│    └───────────────────────┘    │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ Vehicle/Room Card           │ │
│ │ [Large Image]               │ │
│ │ $XX/minute or $XX/night     │ │
│ │ [Booking Button]            │ │
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ Payment Card (Dark theme)   │ │
│ │ **** **** **** 1234         │ │
│ └─────────────────────────────┘ │
│                                 │
│ Status Page (Minimal)           │
│ Loading Spinner → Success ✓    │
└─────────────────────────────────┘
```

---

### Template D: Schedule/Timetable

**Applicable**: School apps, conference agendas

#### Structure

```
┌─────────────────────────────────┐
│ Home View                       │
│ ┌─────┐ ┌─────┐ ┌─────┐        │
│ │Subject│Reco │Subject│ (Grid)  │
│ └─────┘ └─────┘ └─────┘        │
│                                 │
│ Next Class Preview              │
├─────────────────────────────────┤
│ Calendar View                   │
│ [Week View - Top Bar]           │
│ Current date highlighted (Orange)│
│                                 │
│ Timeline:                       │
│ 09:00 ─┬─ [Class Card]          │
│        │   Location + Teacher   │
│ 10:30 ─┼─ [Class Card]          │
│        │                        │
│ 13:00 ─┴─ [Class Card]          │
└─────────────────────────────────┘
```

#### Key Features

- **Home**: Subject recommendations (colored square grid), next class preview
- **Calendar View**: Week view on top, current date highlighted (orange/primary color)
- **Timeline**: Left time axis, right class cards (location, teacher avatar)

---

## Appendix: Quick Reference

### CSS Variables Template

```css
:root {
  /* Colors - Scheme A Example */
  --primary: #5D3FE6;
  --secondary: #FF7B47;
  --background: #FDF3E0;
  --surface: #FFFFFF;
  --text-main: #1F1F1F;
  --text-secondary: #8E8E93;

  /* Spacing */
  --space-1: 8px;
  --space-2: 16px;
  --space-3: 24px;
  --space-4: 32px;
  --space-5: 48px;

  /* Border Radius */
  --radius-sm: 8px;
  --radius-md: 12px;
  --radius-lg: 20px;
  --radius-xl: 24px;
  --radius-pill: 999px;

  /* Shadows */
  --shadow-light: 0 4px 20px rgba(0, 0, 0, 0.05);
  --shadow-float: 0 8px 30px rgba(0, 0, 0, 0.1);

  /* Typography */
  --font-family: 'Inter', sans-serif;
  --font-h1: 700 24px/32px var(--font-family);
  --font-h2: 600 18px/22px var(--font-family);
  --font-h3: 500 16px/18px var(--font-family);
  --font-body: 400 14px/16px var(--font-family);
  --font-caption: 500 12px var(--font-family);
}
```

---

*Document Version: 1.0*
*Last Updated: 2026-03-27*
