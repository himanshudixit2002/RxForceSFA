# RxForce SFA

A comprehensive **Sales Force Automation** application built with Flutter for pharmaceutical field operations. Supports **Web**, **Android**, and **iOS** with an offline-first architecture, AI-powered features, and role-based access control across 5 user roles, 25 database tables, 47 screens, and 8 AI/ML integrations.

**Live URL**: [https://rxforcesfa.web.app](https://rxforcesfa.web.app)

---

## Table of Contents

- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [User Roles and Permissions](#user-roles-and-permissions)
- [Navigation Structure](#navigation-structure)
- [Feature Modules and Use Cases](#feature-modules-and-use-cases)
  - [Authentication](#1-authentication)
  - [MR Dashboard](#2-mr-dashboard)
  - [Daily Call Reports (DCR)](#3-daily-call-reports-dcr)
  - [Doctor Management](#4-doctor-management)
  - [Expense Management](#5-expense-management)
  - [Order Management](#6-order-management)
  - [Tour Planning](#7-tour-planning)
  - [Attendance](#8-attendance)
  - [Leave Management](#9-leave-management)
  - [Sample and Gift Management](#10-sample-and-gift-management)
  - [Product Catalog](#11-product-catalog)
  - [Sales Targets](#12-sales-targets)
  - [Admin Panel](#13-admin-panel)
  - [Manager Panel](#14-manager-panel)
  - [Approval Engine](#15-approval-engine)
  - [Notifications](#16-notifications)
  - [Campaigns](#17-campaigns)
  - [E-Detailing](#18-e-detailing)
  - [Reports and Analytics](#19-reports-and-analytics)
  - [Route Optimizer](#20-route-optimizer)
  - [More Screen](#21-more-screen)
- [AI/ML Integrations](#aiml-integrations)
- [Core Services](#core-services)
- [Database Schema](#database-schema)
- [Route Map](#route-map)
- [Responsive Layout](#responsive-layout)
- [Offline-First Architecture](#offline-first-architecture)
- [Prerequisites](#prerequisites)
- [Local Development Setup](#local-development-setup)
- [Build and Deploy](#build-and-deploy)
- [CI/CD](#cicd-github-actions)

---

## Architecture

```
lib/
├── core/
│   ├── models/          # Enums (UserRole)
│   ├── providers/       # Riverpod providers (auth, DB, repositories)
│   ├── services/        # Sync, notifications, approvals, exports, TTS, speech, OCR, Gemini
│   └── utils/           # Responsive breakpoints, formatters
├── data/
│   ├── models/          # Drift database schema (25 tables, 9 enums)
│   └── repositories/    # Data access layer (one per entity)
├── features/            # 21 feature modules
│   ├── admin/           # User, territory, product, target, sample, campaign management
│   ├── approval/        # Multi-level approval queue and detail
│   ├── attendance/      # Punch-in/out with selfie + GPS, calendar history
│   ├── auth/            # Login and registration
│   ├── campaign/        # Campaign list, detail, and creation
│   ├── dashboard/       # MR home with KPIs, AI recommendations, tour program
│   ├── dcr/             # Voice recording, AI parsing, review
│   ├── doctor/          # List, 360° detail, create/edit forms
│   ├── edetail/         # Content library grid and viewer
│   ├── expense/         # Receipt OCR capture, review, list
│   ├── leave/           # Leave requests with balance tracking
│   ├── manager/         # Manager dashboard and team list
│   ├── more/            # Navigation hub with profile
│   ├── notifications/   # Notification center with deep linking
│   ├── order/           # Order list, creation, detail with status timeline
│   ├── product/         # Product list, detail, admin form
│   ├── reports/         # Sales trends, activity charts, CSV export
│   ├── route_optimizer/ # Google Maps route optimization
│   ├── sample/          # Stock ledger, distribution, admin allocation
│   ├── target/          # Target dashboard, admin assignment
│   └── tour_plan/       # Calendar-based plan creation, list, detail
└── presentation/
    ├── navigation/      # GoRouter config with role guards, responsive shell
    ├── themes/          # Material 3 theme with web enhancements
    └── widgets/         # Shared components (shimmer, error, empty, TTS, offline banner)
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.29+ / Dart 3.10+ |
| State Management | Riverpod 3.x |
| Navigation | GoRouter 17.x with role-based guards |
| Local Database | Drift (SQLite) with web WASM support |
| Backend | Firebase (Auth, Firestore, Cloud Functions, Storage, Remote Config, FCM, Hosting) |
| AI - Speech | `speech_to_text` for voice-to-text DCR recording |
| AI - NLP | Google Generative AI (Gemini 1.5 Flash) for transcript parsing |
| AI - Vision | Google ML Kit Text Recognition for receipt OCR |
| AI - TTS | `flutter_tts` for reading summaries aloud |
| AI - Routes | Google Directions API with waypoint optimization |
| AI - Recommendations | Firebase Cloud Function with Gemini for smart visit suggestions |
| Maps | Google Maps Flutter |
| Charts | fl_chart (bar, line, pie charts) |
| Calendar | table_calendar |
| Image Caching | cached_network_image |
| Background Sync | workmanager |
| Push Notifications | Firebase Cloud Messaging + flutter_local_notifications |

---

## User Roles and Permissions

The application supports 5 hierarchical roles:

| Permission | Super Admin | Admin | Regional Manager | Area Manager | MR |
|-----------|:-----------:|:-----:|:----------------:|:------------:|:--:|
| Admin Dashboard | Yes | Yes | - | - | - |
| Manager Dashboard | - | - | Yes | Yes | - |
| MR Dashboard | - | - | - | - | Yes |
| Manage Users | Yes | Yes | - | - | - |
| Manage Products | Yes | Yes | - | - | - |
| Manage Territories | Yes | Yes | - | - | - |
| Approve Requests | Yes | Yes | Yes | Yes | - |
| View Team | All | All | Region | Area | Self |
| Assign Targets | Yes | Yes | Yes | Yes | - |
| Create Campaigns | Yes | Yes | - | - | - |
| Allocate Samples | Yes | Yes | Yes | Yes | - |
| View All Reports | Yes | Yes | Yes | Yes | - |
| Record DCR | - | - | - | - | Yes |
| Punch Attendance | - | - | - | - | Yes |
| Submit Expenses | - | - | - | - | Yes |

---

## Navigation Structure

### Medical Representative (MR)
| Tab | Route | Purpose |
|-----|-------|---------|
| Home | `/` | Dashboard with KPIs, AI recommendations, today's visits |
| DCR | `/dcr` | Daily Call Report list |
| Tour Plan | `/tour-plan` | Monthly tour plan list |
| Doctors | `/doctors` | Doctor directory |
| More | `/more` | All other features |

### Manager (Regional / Area)
| Tab | Route | Purpose |
|-----|-------|---------|
| Dashboard | `/manager/dashboard` | Team KPIs, pending approvals |
| Team | `/manager/team` | Team members list |
| Approvals | `/manager/approvals` | Pending approval queue |
| Reports | `/manager/reports` | Reports hub |
| More | `/more` | All other features |

### Admin (Super Admin / Admin)
| Tab | Route | Purpose |
|-----|-------|---------|
| Dashboard | `/admin/dashboard` | System KPIs, quick admin actions |
| Users | `/admin/users` | User management |
| Approvals | `/admin/approvals` | Pending approval queue |
| Reports | `/admin/reports` | Reports hub |
| More | `/more` | All other features |

---

## Feature Modules and Use Cases

### 1. Authentication

**Screens**: `LoginScreen`, `RegisterScreen`

| Use Case | Description |
|----------|-------------|
| Email/password login | User enters email and password to authenticate via Firebase Auth |
| Forgot password | Sends a password reset email to the entered address |
| Self-registration | New user creates account with name, email, and password |
| Role-based redirect | After login, the user is automatically redirected to their role-specific dashboard (admin, manager, or MR) |
| Local profile sync | On login, user profile is fetched from Firestore and stored locally in Drift DB for offline access |

---

### 2. MR Dashboard

**Screens**: `DashboardScreen` (with `RecommendedVisitsWidget`, `TourProgramCard`, `PendingSyncBadge`)

| Use Case | Description |
|----------|-------------|
| View daily KPIs | Shows today's DCR count, monthly order count, and pending approval count |
| AI-powered visit suggestions | Calls Firebase Cloud Function `getRecommendedVisits` with the MR's GPS location; displays top 5 doctor recommendations with reason and match score |
| Today's visit schedule | Lists scheduled visits from TourPlanDays with doctor name, specialization, time, and completion status |
| Quick launch DCR | Tap a scheduled visit to launch DCR recording with the doctor pre-filled |
| Quick actions | One-tap access to New DCR, Log Expense, Optimize Route, View Doctors |
| Manual sync | Triggers immediate push/pull sync with Firestore |
| Pending sync indicator | Shows unsynced item count with a cloud icon |
| Sign out | Confirmation dialog before signing out and clearing session |
| Responsive layout | Compact (single column) on mobile, side-by-side on wider screens |

---

### 3. Daily Call Reports (DCR)

**Screens**: `DcrListScreen`, `DcrRecordingScreen`, `DcrReviewScreen`

| Use Case | Description |
|----------|-------------|
| View DCR history | Searchable list of all recorded DCRs showing doctor name, date, products discussed |
| Voice-based recording | Tap the mic to start speech-to-text recording; real-time transcript displayed; pulse animation and timer show recording state |
| Microphone permissions | Automatic permission request with graceful fallback if denied |
| AI transcript parsing (server) | Sends transcript to Firebase Cloud Function `parseDcrTranscript` which uses Gemini to extract structured fields |
| AI transcript parsing (client) | Fallback to on-device Gemini 1.5 Flash model if the Cloud Function fails |
| Review and edit parsed fields | Doctor Name, Products Discussed, Follow-up Date, Additional Notes are pre-filled by AI and editable; "AI" chips indicate auto-extracted fields |
| Pick follow-up date | Calendar date picker for scheduling the next visit |
| Text-to-speech | TTS button reads the original transcript aloud |
| Save DCR | Stores the report locally (Drift) and queues for Firestore sync |
| Activity logging | DCR creation is logged to the ActivityLogs table |
| Unsaved changes guard | Discard confirmation dialog when navigating away from unsaved data |
| Web compatibility | Speech recognition is disabled on web with a user-friendly message |

---

### 4. Doctor Management

**Screens**: `DoctorListScreen`, `DoctorDetailScreen`, `DoctorFormScreen`

| Use Case | Description |
|----------|-------------|
| Browse doctors | Scrollable list with avatar initials, name, specialization, clinic address, last visit date |
| Search doctors | Real-time search by name, specialization, or clinic address |
| Filter by specialization | Horizontal chip row to filter by specialty (e.g., Cardiologist, Dermatologist) |
| Responsive grid | Grid layout on tablet/desktop, list on mobile |
| Doctor 360° view | Tabbed detail screen: Overview, Visits, Samples, Orders |
| Overview tab | Contact info (phone, address, GPS coordinates on map), classification (A/B/C), visit frequency, conversion probability bar chart |
| Visits tab | Historical list of all visits to this doctor with date, outcome, and completion status |
| Samples tab | History of all samples/gifts distributed to this doctor |
| Orders tab | All orders linked to this doctor |
| Quick actions | Bottom buttons: Record DCR (pre-fills doctor), Distribute Sample (pre-fills doctor), Create Order (pre-fills doctor) |
| Edit doctor | Navigate to form with pre-filled data |
| Add new doctor | Form with name, specialization, address, phone, territory, classification, lat/lng |
| TTS summary | Read a spoken summary of the doctor's profile and stats |
| Hero animation | Avatar animates from list card to detail screen header |

---

### 5. Expense Management

**Screens**: `ExpenseListScreen`, `ReceiptCaptureScreen`, `ExpenseReviewScreen`

| Use Case | Description |
|----------|-------------|
| View expense history | List with amount (INR), date, category, approval status, and warning flag |
| Capture receipt photo | Take a photo with camera or pick from gallery |
| OCR receipt scanning | Google ML Kit extracts amount (regex patterns for Rs, Total, Amount, Grand Total) and date from the receipt image |
| Review extracted data | Amount and date are pre-filled from OCR; user selects category (meal, travel, accommodation, other) |
| Meal allowance limit | Dynamic meal limit fetched from Firebase Remote Config; warning flag auto-set if exceeded |
| Receipt image upload | Receipt photo uploaded to Firebase Storage on save |
| TTS for OCR text | Read the raw extracted text aloud |
| Activity logging | Expense submission logged to ActivityLogs |
| Submit for approval | Creates an approval request for the manager/admin |
| Unsaved changes guard | Confirmation dialog on back navigation |
| Web compatibility | Camera features disabled on web with fallback message |

---

### 6. Order Management

**Screens**: `OrderListScreen`, `OrderDetailScreen`, `OrderCreateScreen`

| Use Case | Description |
|----------|-------------|
| View order list | Status-colored list (grey=draft, orange=submitted, blue=confirmed, purple=dispatched, green=delivered, red=cancelled) |
| Create order | Add product line items from catalog dropdown; set quantity and discount per item; auto-calculated total |
| Pre-fill doctor | When launched from doctor detail, the doctor is pre-selected |
| Order detail view | Full order info with status timeline showing progression: Draft → Submitted → Confirmed → Dispatched → Delivered |
| Cancel order | Available only for draft orders |
| Submit order | Available only for draft orders; changes status and creates approval record |
| Confirm order | Available only for submitted orders (admin/manager action) |
| View line items | List of all products in the order with name, quantity, price, discount, and subtotal |
| Activity logging | Order creation logged to ActivityLogs |
| Hero animation | Order icon animates from list to detail |

---

### 7. Tour Planning

**Screens**: `TourPlanListScreen`, `TourPlanDetailScreen`, `TourPlanCreateScreen`

| Use Case | Description |
|----------|-------------|
| View tour plans | List of monthly plans with month/year and status chips (draft, submitted, approved, rejected) |
| Create monthly plan | Interactive `TableCalendar` with event markers; tap a day to assign doctors |
| Add doctors to a day | Dialog with full doctor list and checkboxes for multi-selection |
| Remove doctors | Remove individual doctors from a day |
| Save as draft | Stores locally with draft status |
| Submit for approval | Changes status from draft to submitted; creates an approval record |
| View plan detail | Expandable day cards showing assigned doctors; day count and status |
| Activity logging | Tour plan creation logged |

---

### 8. Attendance

**Screens**: `AttendanceScreen`, `AttendanceHistoryScreen`

| Use Case | Description |
|----------|-------------|
| Punch in | Captures front camera selfie + GPS coordinates; records punch-in time |
| Punch out | Captures GPS coordinates; records punch-out time |
| Current status display | Shows "Not Punched In", "Working" (with timer), or "Day Complete" (with total hours) |
| View attendance history | Calendar view (`TableCalendar`) with attendance markers |
| Day detail | Tap a day to see punch-in time, punch-out time, status (present, absent, halfDay, leave, holiday) |
| History navigation | "History" button in AppBar navigates to calendar view |
| Web compatibility | Camera and GPS disabled on web with user-friendly message |

---

### 9. Leave Management

**Screen**: `LeaveRequestScreen`

| Use Case | Description |
|----------|-------------|
| View leave balances | Chips showing remaining/total for each leave type: Casual, Sick, Earned, Comp-Off |
| View leave history | List of all leave requests with type, date range, reason, and status |
| Apply for leave | Dialog with leave type dropdown, date range picker, reason text field |
| Status tracking | Color-coded: green=approved, red=rejected, orange=pending, blue=escalated |
| Submit for approval | Automatically creates an approval request |
| Activity logging | Leave request submission logged |

---

### 10. Sample and Gift Management

**Screens**: `SampleStockScreen`, `SampleDistributionScreen`, `SampleAllocationScreen`

| Use Case | Description |
|----------|-------------|
| View stock ledger | Per-product stock with opening, received, distributed, and closing quantities |
| Distribute sample | Toggle between Sample and Gift; select product, set quantity, enter batch number, select doctor |
| Pre-fill doctor | When launched from doctor detail, doctor is pre-selected |
| Admin: allocate stock | Enter MR User ID, select product, set quantity; updates stock ledger |
| Batch tracking | Optional batch number and expiry date for traceability |

---

### 11. Product Catalog

**Screens**: `ProductListScreen`, `ProductDetailScreen`, `ProductFormScreen`

| Use Case | Description |
|----------|-------------|
| Browse products | Searchable list with name, category, SKU, price, and active/inactive status |
| Product detail | Full detail card with SKU, category, division, price, status, description |
| Admin: create product | Form with product name, SKU, category, division, price, description, active toggle |
| Admin: edit product | Pre-filled form for updating existing products |
| Hero animation | Product avatar animates from list to detail |

---

### 12. Sales Targets

**Screens**: `TargetDashboardScreen`, `TargetAssignScreen`

| Use Case | Description |
|----------|-------------|
| View target dashboard | Overall achievement percentage with circular progress indicator; per-target cards with linear progress bars showing target vs achieved |
| Visual progress | Color-coded progress (green > 75%, orange 50-75%, red < 50%) |
| Admin: assign target | Set MR User ID, target type (monthly/quarterly), optional product, target value, and period |

---

### 13. Admin Panel

**Screens**: `AdminDashboardScreen`, `UserManagementScreen`, `UserFormScreen`, `TerritoryManagementScreen`, `TerritoryFormScreen`

| Use Case | Description |
|----------|-------------|
| Admin dashboard | KPI cards: Total Users, Pending Approvals, Active MRs |
| Quick actions | Add User, Territories, Products, Targets, Campaigns, New Product, New Campaign, Assign Target, Allocate Samples |
| View top approvals | Lists top 5 pending approvals with type and navigation |
| Manage users | Searchable list filterable by role; shows name, email, role, active status |
| Create user | Form: Full Name, Email, Phone, Role (all 5 roles), Territory (dropdown), Reports To (dropdown), Active toggle |
| Edit user | Pre-filled form for updating user details |
| Manage territories | Hierarchical tree view with parent/child relationships and levels 0-4 |
| Create territory | Form: Territory Name, Parent Territory (dropdown), Level |
| Edit territory | Pre-filled form for updating territory details |
| Activity logging | User creation/update logged |

---

### 14. Manager Panel

**Screens**: `ManagerDashboardScreen`, `TeamListScreen`

| Use Case | Description |
|----------|-------------|
| Manager dashboard | KPI cards: Team Members count, Pending Approvals count for their team |
| Quick actions | View Team, Approvals, Reports, Assign Targets, Allocate Samples |
| View top approvals | Lists top 5 pending approvals with drill-down |
| View team | List of MRs whose `parentId` matches the manager; shows name, email, active/inactive |
| Drill-down | Tap a team member to view/edit their profile |

---

### 15. Approval Engine

**Screens**: `ApprovalQueueScreen`, `ApprovalDetailScreen`

| Use Case | Description |
|----------|-------------|
| View pending approvals | Filterable queue showing type (expense, tour plan, leave, order, sample), requester, date, status |
| Review approval | Full detail view with type, requester info, date, current status, comments |
| Approve request | Changes status to approved; sends notification to requester |
| Reject request | Adds rejection comments; changes status to rejected; notifies requester |
| Multi-level support | Supports escalation status for complex approval chains |
| Activity logging | Both submission and processing actions logged |

**Supported Approval Types**:
- Leave requests
- Expense claims
- Tour plans
- Orders
- Sample allocations

---

### 16. Notifications

**Screen**: `NotificationListScreen`

| Use Case | Description |
|----------|-------------|
| View notifications | Chronological list with type-specific icons (approval, reminder, alert, system) |
| Read/unread status | Visual distinction between read and unread notifications |
| Mark all read | Bulk action to mark all notifications as read |
| Deep link navigation | Tap a notification to navigate directly to the referenced entity (order, approval, etc.) |
| Push notifications | Firebase Cloud Messaging for real-time push |
| Foreground display | Local notification shown when app is in foreground |
| Background handling | Tap a background notification to open the app at the relevant screen |

---

### 17. Campaigns

**Screens**: `CampaignListScreen`, `CampaignDetailScreen`, `CampaignCreateScreen`

| Use Case | Description |
|----------|-------------|
| Browse campaigns | List with name, date range, and active/inactive status chip |
| Campaign detail | Name, status badge, start/end dates, days remaining, description, target doctor list |
| Admin: create campaign | Form: Campaign Name, Description, Start Date, End Date, Target Doctors (multi-select checkbox list) |

---

### 18. E-Detailing

**Screens**: `EDetailLibraryScreen`, `EDetailViewerScreen`

| Use Case | Description |
|----------|-------------|
| Browse content library | Responsive grid of e-detailing materials with title, type badge (PDF, Video, Image), product association |
| View content metadata | Title, type, product ID, version, active status, URL |
| Open content | Button to open the content URL externally |

---

### 19. Reports and Analytics

**Screens**: `ReportsHomeScreen`, `SalesReportScreen`, `ActivityReportScreen`

| Use Case | Description |
|----------|-------------|
| Reports hub | 7 report categories with navigation cards: Sales, Activity, Attendance, Expense, Sample, Tour Deviation, Target Achievement |
| Sales report | Monthly Sales Trend (bar chart via fl_chart), Product-wise Split (pie chart) |
| Activity report | KPI cards: Total Calls, Coverage %, Frequency; Daily Calls line chart |
| Export to CSV | Both sales and activity reports can be exported to CSV and shared via the system share sheet |
| Deep-link reports | Each report type card navigates to its specific screen or re-uses existing list screens (attendance, expense, sample, tour plan, target) |

---

### 20. Route Optimizer

**Screen**: `RouteMapScreen`

| Use Case | Description |
|----------|-------------|
| View daily visits on map | Google Maps with markers for today's unfinished visits (geo-located doctors) |
| Optimize route | Calls Google Directions API with `optimize:true` to find the shortest route through all waypoints |
| View optimized route | Polyline overlay on map showing the optimized path |
| Route summary | Bottom sheet showing ordered waypoints, total distance, and total duration |
| Mark availability | Toggle individual doctors as available/unavailable for the day |
| GPS integration | Starts route from the MR's current GPS location |
| Web compatibility | GPS features are skipped on web; route origin defaults to the first waypoint |

---

### 21. More Screen

**Screen**: `MoreScreen`

| Use Case | Description |
|----------|-------------|
| User profile | Avatar, name, email, and role badge at the top |
| Field Operations | Expenses, Route Optimizer, Attendance, Attendance History, Leave, Add Doctor |
| Products and Samples | Products, Samples, Orders |
| Content and Campaigns | E-Detailing, Campaigns |
| Analytics | Reports, Targets (visible to managers and admins only) |
| Settings | Notifications, Logout |

---

## AI/ML Integrations

| # | Feature | Technology | How It Works |
|---|---------|-----------|-------------|
| 1 | **Voice-to-Text DCR** | `speech_to_text` | Real-time microphone transcription with 5-minute sessions and 10-second pause detection; streaming results to UI |
| 2 | **AI DCR Parsing (Server)** | Firebase Cloud Function + Gemini | Sends transcript to `parseDcrTranscript` function; server-side Gemini extracts doctor name, products discussed, and follow-up date as structured JSON |
| 3 | **AI DCR Parsing (Client)** | `google_generative_ai` (Gemini 1.5 Flash) | Fallback on-device parsing with a system prompt tailored for medical call reports; handles markdown-fenced JSON responses |
| 4 | **Receipt OCR** | `google_mlkit_text_recognition` (ML Kit) | Scans receipt images to extract total amount (multiple regex patterns for INR formats) and date (dd/mm/yyyy, yyyy-mm-dd) |
| 5 | **Smart Visit Recommendations** | Firebase Cloud Function + Gemini | `getRecommendedVisits` analyzes MR's GPS location and visit history to suggest the top 5 doctors to visit with reason and match score |
| 6 | **Route Optimization** | Google Directions API | Waypoint optimization (`optimize:true`) for daily visit routes; polyline decoding; distance/duration calculation |
| 7 | **Text-to-Speech** | `flutter_tts` | Reads doctor summaries, DCR transcripts, and OCR-extracted text aloud; supports play/stop/pause controls |
| 8 | **Conversion Probability** | Server-computed score | Color-coded probability bar on doctor detail screen (green > 70%, orange 40-70%, red < 40%) |

---

## Core Services

| Service | Capabilities |
|---------|-------------|
| **SyncService** | Offline-first bidirectional sync with Firestore; pushes local changes with exponential backoff (up to 10 retries); pulls 21 collection types; receipt image upload; background sync via WorkManager |
| **ApprovalService** | Submits items for approval (creates approval record + sends notification); processes approvals (approve/reject + notifies requester); activity logging for audit |
| **NotificationService** | Firebase Cloud Messaging init; FCM token management; foreground/background message handling; local notifications via `flutter_local_notifications`; deep-link routing from notification tap |
| **ExportService** | Exports data to CSV files; exports plain text; shares via system share sheet (`share_plus`) |
| **TtsService** | Text-to-Speech singleton; play/stop/pause controls; iOS audio category configuration; state streaming |
| **StorageService** | Upload/delete receipt images to Firebase Storage; download URL management; web/mobile file handling |
| **SpeechService** | Speech recognition init; start/stop listening (5-min sessions, 10s pause detection); streaming transcript via StreamController |
| **GeminiDcrParser** | Gemini 1.5 Flash model integration; system prompt for medical call report parsing; JSON extraction from AI response |
| **OcrService** | ML Kit text recognition; multi-pattern amount extraction (Rs, Total, Grand Total); multi-format date extraction |
| **RouteOptimizerService** | Google Directions API with waypoint optimization; polyline decoding; distance/duration formatting |

---

## Database Schema

25 tables with 9 enums supporting complete offline operation:

| Table | Key Fields | Purpose |
|-------|-----------|---------|
| **SyncQueueItems** | collectionName, documentId, operationType, payload, isSynced, retryCount | Offline sync queue |
| **Users** | id, email, name, role, parentId, territoryId, isActive | User accounts with hierarchy |
| **Doctors** | id, name, specialization, clinicAddress, territory, classification, latitude/longitude, conversionProbability | Doctor master data |
| **Dcrs** | id, doctorName, doctorId, productsDiscussed, samplesGiven, notes, callDuration, geoLat/geoLng, mrId | Daily Call Reports |
| **Visits** | id, doctorId, mrId, visitDate, notes, outcome, isCompleted | Planned and actual visits |
| **Expenses** | id, amount, date, category, receiptImagePath, isApproved, warningFlag, mrId | Expense claims |
| **Orders** | id, mrId, doctorId, status, totalAmount, orderDate, deliveryDate | Order headers |
| **OrderItems** | id, orderId, productId, quantity, price, discount | Order line items |
| **Products** | id, name, sku, category, division, price, description, isActive | Product catalog |
| **Samples** | id, productId, mrId, doctorId, quantity, batchNo, expiryDate, type | Sample/gift distribution |
| **StockLedgers** | id, productId, mrId, openingStock, received, distributed, closingStock | Inventory tracking |
| **TourPlans** | id, mrId, month, year, status, approvedBy | Monthly tour plans |
| **TourPlanDays** | id, tourPlanId, date, doctorIds (JSON), isCompleted | Day-wise assignments |
| **Attendances** | id, mrId, date, punchInTime, punchInLat/Lng, punchInSelfie, punchOutTime, punchOutLat/Lng, status | Geo-fenced attendance |
| **LeaveRequests** | id, mrId, leaveType, startDate, endDate, reason, status, approvedBy | Leave applications |
| **LeaveBalances** | id, mrId, leaveType, total, used, remaining, year | Leave balance tracker |
| **Targets** | id, mrId, productId, targetType, targetValue, achievedValue, period | Sales targets |
| **Approvals** | id, type, referenceId, requesterId, approverId, status, comments | Generic approval records |
| **Notifications** | id, userId, title, body, type, referenceId, isRead | In-app notifications |
| **Campaigns** | id, name, startDate, endDate, description, targetDoctors (JSON), status | Marketing campaigns |
| **EDetailContents** | id, productId, title, type, url, version, isActive | E-detailing content |
| **Territories** | id, name, parentId, level, boundaries (JSON) | Territory hierarchy |
| **Recommendations** | id, doctorName, specialization, address, score, reason, mrId | AI visit suggestions |
| **ActivityLogs** | id, userId, action, entityType, entityId, details, timestamp | Audit trail |
| **AppSettings** | key, value | Key-value settings |

**Enums**: `OperationType`, `ExpenseCategory`, `ApprovalStatus`, `OrderStatus`, `LeaveType`, `AttendanceStatus`, `ApprovalEntityType`, `NotificationType`, `TargetType`

---

## Route Map

### Shell Routes (with navigation bar)

| Route | Screen | Roles |
|-------|--------|-------|
| `/` | MR Dashboard | MR |
| `/dcr` | DCR List | MR |
| `/tour-plan` | Tour Plan List | MR |
| `/doctors` | Doctor List | MR |
| `/more` | More Screen | All |
| `/admin/dashboard` | Admin Dashboard | Admin |
| `/admin/users` | User Management | Admin |
| `/admin/approvals` | Approval Queue | Admin |
| `/admin/reports` | Reports Hub | Admin |
| `/manager/dashboard` | Manager Dashboard | Manager |
| `/manager/team` | Team List | Manager |
| `/manager/approvals` | Approval Queue | Manager |
| `/manager/reports` | Reports Hub | Manager |
| `/notifications` | Notification Center | All |
| `/products` | Product List | All |
| `/samples` | Stock Ledger | All |
| `/orders` | Order List | All |
| `/targets` | Target Dashboard | All |
| `/edetail` | E-Detail Library | All |
| `/campaigns` | Campaign List | All |
| `/attendance` | Attendance | All |
| `/leave` | Leave Requests | All |
| `/reports` | Reports Hub | All |
| `/expenses` | Expense List | All |

### Full-Screen Routes

| Route | Screen | Notes |
|-------|--------|-------|
| `/login` | Login | Unauthenticated only |
| `/register` | Register | Unauthenticated only |
| `/dcr/record` | Voice Recording | Accepts doctorName, visitId extras |
| `/dcr/review` | AI Review | Accepts transcript, doctorName, visitId |
| `/expense/capture` | Receipt Capture | Camera/gallery |
| `/expense/review` | Expense Review | Accepts OCR extracted data |
| `/route` | Route Optimizer | Google Maps |
| `/orders/:orderId` | Order Detail | Status timeline |
| `/orders/create` | Create Order | Accepts doctorId extra |
| `/doctors/new` | Add Doctor | Form |
| `/doctors/:doctorId` | Doctor 360° | Accepts Doctor extra |
| `/doctors/:doctorId/edit` | Edit Doctor | Form |
| `/tour-plan/create` | Create Tour Plan | Calendar |
| `/tour-plan/:planId` | Tour Plan Detail | Expandable days |
| `/products/:productId` | Product Detail | |
| `/samples/distribute` | Distribute Sample | Accepts doctorId extra |
| `/campaigns/:campaignId` | Campaign Detail | |
| `/edetail/:contentId` | E-Detail Viewer | |
| `/attendance/history` | Attendance Calendar | |
| `/admin/users/:userId` | User Form | Admin only |
| `/admin/territories` | Territory List | Admin only |
| `/admin/territories/:id` | Territory Form | Admin only |
| `/admin/products/create` | Product Form | Admin only |
| `/admin/products/:id` | Edit Product | Admin only |
| `/admin/targets/assign` | Assign Target | Admin/Manager |
| `/admin/samples/allocate` | Allocate Samples | Admin/Manager |
| `/admin/campaigns/create` | Create Campaign | Admin only |
| `/admin/approvals/:id` | Approval Detail | Admin/Manager |
| `/reports/sales` | Sales Charts | |
| `/reports/activity` | Activity Charts | |

### Route Guards
- Unauthenticated users redirected to `/login`
- Post-login redirect: Admin to `/admin/dashboard`, Manager to `/manager/dashboard`, MR to `/`
- `/admin/*` restricted to Admin roles
- `/manager/*` restricted to Manager and Admin roles

---

## Responsive Layout

| Breakpoint | Width | Navigation | Content Width |
|-----------|-------|-----------|--------------|
| Compact (mobile) | < 600px | Bottom NavigationBar | Full width |
| Medium (tablet) | 600 - 1200px | NavigationRail | Max 840px centered |
| Expanded (desktop) | > 1200px | Permanent NavigationDrawer | Max 1200px centered |

Additional web enhancements:
- Visible scrollbars with hover state
- `VisualDensity.standard` (vs compact on mobile)
- Clickable mouse cursor on list tiles
- Form screens use `adaptiveFormMaxWidth` (max 700px)

---

## Offline-First Architecture

1. **Local Database**: All data stored in Drift (SQLite) database with 25 tables
2. **Sync Queue**: Every write operation creates a `SyncQueueItem` with the Firestore collection, document ID, operation type, and JSON payload
3. **Push Sync**: On connectivity, queued items are pushed to Firestore with exponential backoff (up to 10 retries per item)
4. **Pull Sync**: All 21 Firestore collections are pulled and upserted into the local database
5. **Background Sync**: WorkManager triggers periodic sync even when the app is in the background
6. **Conflict Resolution**: Last-write-wins via `insertOnConflictUpdate`
7. **Receipt Upload**: Image files are uploaded to Firebase Storage during sync, and the local path is replaced with the download URL

---

## Prerequisites

- Flutter SDK >= 3.29.0
- Firebase CLI (`npm install -g firebase-tools`)
- A Firebase project with: Firestore, Auth, Storage, Cloud Functions, Remote Config, FCM, Hosting
- API keys: `GEMINI_API_KEY`, `MAPS_API_KEY`

## Local Development Setup

```bash
git clone <repo-url> && cd RxForceSFA

flutter pub get

# Generate Drift database code (if schema changed)
dart run build_runner build --delete-conflicting-outputs

# Run on Chrome
flutter run -d chrome \
  --dart-define=GEMINI_API_KEY=your_key \
  --dart-define=MAPS_API_KEY=your_key

# Run on Android
flutter run -d <device_id> \
  --dart-define=GEMINI_API_KEY=your_key \
  --dart-define=MAPS_API_KEY=your_key
```

## Build and Deploy

### Web (Firebase Hosting)

```bash
flutter build web --release \
  --dart-define=GEMINI_API_KEY=your_key \
  --dart-define=MAPS_API_KEY=your_key

firebase deploy --only hosting
```

### Android Release APK

1. Create a release keystore:

```bash
keytool -genkey -v -keystore android/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties` (see `android/key.properties.example`):

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

3. Build:

```bash
flutter build apk --release \
  --dart-define=GEMINI_API_KEY=your_key \
  --dart-define=MAPS_API_KEY=your_key
```

## CI/CD (GitHub Actions)

The `.github/workflows/deploy.yml` workflow automates:
- **On push to `main`**: Analyze, test, build web, deploy to Firebase Hosting
- **On tag `v*`**: Build Android APK/AAB, create GitHub Release with artifacts

Required repository secrets:

| Secret | Description |
|--------|-------------|
| `FIREBASE_SERVICE_ACCOUNT` | Firebase service account JSON for hosting deploy |
| `GEMINI_API_KEY` | Google Generative AI API key |
| `MAPS_API_KEY` | Google Maps API key |
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded upload keystore |
| `ANDROID_STORE_PASSWORD` | Keystore store password |
| `ANDROID_KEY_PASSWORD` | Keystore key password |
