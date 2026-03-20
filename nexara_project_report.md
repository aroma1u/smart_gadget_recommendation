# NEXARA — AI-Powered Smart Gadget Recommendation System

## Complete Project Documentation for Project Report Generation

---

## 1. PROJECT OVERVIEW

### 1.1 Project Title
**Nexara — AI-Powered Smart Gadget Recommendation System**

### 1.2 Project Summary
Nexara is a full-stack Flutter Web application that provides intelligent, AI-powered gadget recommendations to users. The system leverages Google's Gemini 2.5 Flash generative AI model to analyze user preferences (budget, brand, usage pattern, RAM, storage, camera quality, battery life) and recommend the top 5 best-matching gadgets from a curated catalog. The application features a modern, premium dark-mode UI with glassmorphism effects, animated mesh gradients, responsive layouts, gadget comparison tools, favorites management, user authentication via Firebase, and a fully automated CI/CD pipeline deploying to AWS EC2 via Docker and GitHub Actions.

### 1.3 Problem Statement
Consumers today face an overwhelming number of gadget choices across categories like smartphones, laptops, tablets, smartwatches, headphones, and smart home devices. With thousands of specifications to compare and hundreds of brands to evaluate, making an informed purchase decision is time-consuming and confusing. There is a need for an intelligent recommendation system that understands individual user preferences and provides personalized, data-driven gadget suggestions.

### 1.4 Proposed Solution
Nexara addresses this problem by combining a curated gadget catalog with Google Gemini AI to deliver personalized recommendations. Users fill out a preference form specifying their requirements, and the AI engine analyzes thousands of specifications against the user's profile to produce the top 5 best matches. The system provides GSMArena-style detailed specification sheets for each recommendation, allowing users to compare devices side-by-side.

### 1.5 Key Objectives
1. Build a responsive Flutter Web application with a premium, modern UI
2. Integrate Google Gemini 2.5 Flash AI for intelligent gadget recommendations
3. Implement user authentication (Email/Password + Google Sign-In) via Firebase
4. Provide a comprehensive gadget catalog with category browsing
5. Enable side-by-side gadget comparison (up to 3 devices)
6. Include favorites/bookmarking functionality
7. Deploy using Docker containers on AWS EC2 with automated CI/CD via GitHub Actions
8. Support both dark and light themes with smooth transitions

---

## 2. TECHNOLOGY STACK

### 2.1 Frontend Framework
| Technology | Version | Purpose |
|---|---|---|
| **Flutter** | SDK ^3.10.1 | Cross-platform UI framework (targeting Web) |
| **Dart** | Latest stable | Programming language |

### 2.2 State Management & Routing
| Package | Version | Purpose |
|---|---|---|
| **flutter_riverpod** | ^3.3.1 | Reactive state management with providers and notifiers |
| **go_router** | ^17.1.0 | Declarative URL-based routing with deep linking |

### 2.3 Backend & AI Services
| Technology | Version | Purpose |
|---|---|---|
| **Google Gemini 2.5 Flash** | API v1beta | Generative AI for recommendations |
| **google_generative_ai** | ^0.4.7 | Dart SDK for Gemini API |
| **Firebase Auth** | ^6.2.0 | Email/Password and Google Sign-In authentication |
| **Cloud Firestore** | ^6.1.3 | NoSQL cloud database for gadgets and user profiles |
| **firebase_core** | ^4.5.0 | Firebase initialization |

### 2.4 UI & Design
| Package | Version | Purpose |
|---|---|---|
| **google_fonts** | ^8.0.2 | Premium typography (Inter, Outfit) |
| **cupertino_icons** | ^1.0.8 | iOS-style icons |
| **url_launcher** | ^6.3.2 | External URL handling |

### 2.5 Configuration & Environment
| Package | Version | Purpose |
|---|---|---|
| **flutter_dotenv** | ^6.0.0 | Secure environment variable management (.env) |

### 2.6 DevOps & Deployment
| Technology | Purpose |
|---|---|
| **Docker** (Nginx Alpine) | Containerization for production deployment |
| **Docker Compose** | Multi-container orchestration |
| **GitHub Actions** | CI/CD pipeline automation |
| **AWS EC2** | Cloud hosting (production server) |
| **Docker Hub** | Container image registry |
| **Nginx** | Static file serving with SPA routing |

---

## 3. SYSTEM ARCHITECTURE

### 3.1 Architecture Diagram (High-Level)

```
┌──────────────────────────────────────────────────────────┐
│                    USER (Browser)                        │
│              Flutter Web Application                     │
│         (Dart compiled to JavaScript/WASM)               │
└──────────────────┬───────────────────────────────────────┘
                   │
        ┌──────────┼──────────┐
        │          │          │
        ▼          ▼          ▼
┌───────────┐ ┌─────────┐ ┌──────────────┐
│ Firebase  │ │ Gemini  │ │  GSMArena    │
│ Auth +    │ │ 2.5     │ │  Image CDN   │
│ Firestore │ │ Flash   │ │  (via weserv │
│           │ │ API     │ │   proxy)     │
└───────────┘ └─────────┘ └──────────────┘
```

### 3.2 Application Layer Architecture

```
┌─ lib/
│  ├── main.dart                          [Entry Point]
│  ├── models/                            [Data Layer]
│  │   ├── gadget_model.dart              [Gadget entity]
│  │   └── user_model.dart                [User entity]
│  ├── services/                          [Business Logic Layer]
│  │   ├── auth_service.dart              [Firebase Authentication]
│  │   ├── firestore_service.dart         [Cloud Firestore CRUD]
│  │   └── gemini_service.dart            [Gemini AI Integration]
│  ├── providers/                         [State Management Layer]
│  │   ├── auth_provider.dart             [Auth state providers]
│  │   ├── gadget_provider.dart           [Gadget data + compare + favorites]
│  │   ├── ai_recommendation_provider.dart [AI recommendation state]
│  │   └── theme_provider.dart            [Dark/Light mode state]
│  ├── screens/                           [Presentation Layer - Pages]
│  │   ├── auth_screen.dart               [Login/Signup page]
│  │   ├── home_screen.dart               [Main landing page]
│  │   ├── recommendation_form_screen.dart [Preference input form]
│  │   ├── recommendation_results_screen.dart [AI results display]
│  │   ├── details_screen.dart            [Gadget detail view]
│  │   ├── comparison_screen.dart         [Side-by-side comparison]
│  │   ├── categories_screen.dart         [Category browser]
│  │   ├── favorites_screen.dart          [Saved gadgets]
│  │   ├── profile_screen.dart            [User profile & settings]
│  │   └── admin_dashboard.dart           [Admin panel (WIP)]
│  ├── widgets/                           [Reusable UI Components]
│  │   ├── gadget_card.dart               [Product card with glassmorphism]
│  │   ├── mesh_gradient.dart             [Animated mesh gradient]
│  │   ├── spec_chip.dart                 [Specification display chip]
│  │   └── tech_button.dart               [Styled action button]
│  └── utils/                             [Utilities]
│      ├── constants.dart                 [App constants & categories]
│      ├── router.dart                    [GoRouter configuration]
│      └── theme.dart                     [Material 3 theme definitions]
```

### 3.3 Design Pattern
The project follows the **MVVM (Model-View-ViewModel)** pattern adapted for Flutter with Riverpod:
- **Model**: `GadgetModel`, `UserModel` — Plain Dart classes with serialization
- **View**: Screen widgets (ConsumerWidget/ConsumerStatefulWidget)
- **ViewModel**: Riverpod Notifiers (`CompareNotifier`, `FavoritesNotifier`, `AiRecommendationNotifier`, `ThemeNotifier`)

---

## 4. DETAILED MODULE DESCRIPTIONS

### 4.1 Data Models

#### 4.1.1 GadgetModel (`lib/models/gadget_model.dart`)
Represents a consumer electronics gadget with the following fields:

| Field | Type | Description |
|---|---|---|
| `id` | String | Unique identifier (Firestore document ID or auto-generated) |
| `category` | String | Product category (Smartphones, Laptops, Tablets, etc.) |
| `name` | String | Full product name (e.g., "Samsung Galaxy S24 Ultra") |
| `brand` | String | Brand name (Samsung, Apple, Google, etc.) |
| `price` | double | Price in INR |
| `imageUrl` | String | URL or asset path for product image |
| `rating` | double | User rating (0.0 - 5.0) |
| `shortDesc` | String | Brief product description |
| `specs` | Map<String, dynamic> | Key-value specifications (Display, Platform, Memory, Camera, Battery, etc.) |
| `reviews` | List<String> | User review text entries |
| `trending` | bool | Whether the gadget is currently trending |

Includes `fromMap()` factory constructor for Firestore deserialization and `toMap()` for serialization.

#### 4.1.2 UserModel (`lib/models/user_model.dart`)
Represents an authenticated user:

| Field | Type | Description |
|---|---|---|
| `uid` | String | Firebase Auth UID |
| `email` | String | User email address |
| `displayName` | String | User display name |
| `photoUrl` | String | Profile photo URL |
| `favoriteGadgetIds` | List<String> | List of favorited gadget IDs |
| `role` | String | User role ('user' or 'admin') |

Includes `fromMap()`, `toMap()`, and `copyWith()` methods.

---

### 4.2 Services Layer

#### 4.2.1 GeminiService (`lib/services/gemini_service.dart`) — **Core AI Engine**

This is the heart of the application. It integrates with Google's Gemini 2.5 Flash generative AI model to produce personalized gadget recommendations.

**Key Features:**
- Uses `google_generative_ai` package with model `gemini-2.5-flash`
- API key loaded securely from `.env` file via `flutter_dotenv`
- Graceful fallback to mock data when API key is unavailable
- Accepts 8 user preference parameters:
  - `gadgetCategory` — Type of gadget (Smartphones, Laptops, etc.)
  - `budget` — Maximum budget in INR
  - `brandPref` — Preferred brand
  - `usage` — Primary use case (Gaming, Photography, Daily use, etc.)
  - `ram` — Minimum RAM requirement
  - `storage` — Minimum storage requirement
  - `cameraQuality` — Camera importance level
  - `batteryCapacity` — Battery life importance level

**AI Prompt Engineering:**
The service constructs a sophisticated prompt that:
1. Describes the user as a consumer electronics buyer with specific needs
2. Provides the full catalog of available gadgets from Firestore/dummy data
3. Instructs the AI to recommend from both stock AND brand-new cutting-edge devices
4. Requests exactly 5 recommendations in strict JSON format
5. Each recommendation includes full GSMArena-style specification sheets covering: Network, Launch, Body, Display, Platform, Memory, Main Camera, Selfie Camera, Sound, Comms, Features, Battery, Misc
6. Requests a `gsmarenaSlug` field to auto-generate device images from GSMArena's CDN

**Post-Processing:**
- Strips markdown code blocks from AI response
- Parses JSON array of recommendation objects
- Builds device image URLs from GSMArena slugs using a CORS proxy (`images.weserv.nl`)
- Pads results to minimum 5 recommendations using fallback gadgets from the catalog sorted by budget proximity

**Image URL Strategy:**
```
GSMArena CDN → https://fdn2.gsmarena.com/vv/bigpic/{slug}.jpg
CORS Proxy  → https://images.weserv.nl/?url={directUrl}
```

**Safe Image Pool (Fallback URLs):**
- Smartphones: Unsplash photo IDs for generic smartphone images
- Laptops, Tablets, Smartwatches, Headphones, Cameras, Smart Home: Each with dedicated fallback URLs

#### 4.2.2 AuthService (`lib/services/auth_service.dart`)

Firebase Authentication service supporting:
- **Email/Password Sign Up** — With display name, restricted to `@gmail.com` accounts
- **Email/Password Login** — Standard credential-based login
- **Google Sign-In** — Using `signInWithPopup()` for web, with Gmail-only enforcement
- **Logout** — Firebase sign-out
- **Security**: Non-Gmail accounts are automatically deleted from Firebase Auth if created via Google Sign-In

#### 4.2.3 FirestoreService (`lib/services/firestore_service.dart`)

Cloud Firestore CRUD operations:
- **Users Collection**: `createUserProfile()`, `getUserProfile()`
- **Gadgets Collection**: `getGadgets()` (all), `getGadgetsByCategory()`, `getTrendingGadgets()`
- **Favorites**: `toggleFavorite()` using Firestore `arrayUnion` / `arrayRemove`
- All gadget queries return `Stream<List<GadgetModel>>` for real-time updates

---

### 4.3 State Management (Riverpod Providers)

#### 4.3.1 Auth Providers (`lib/providers/auth_provider.dart`)
| Provider | Type | Purpose |
|---|---|---|
| `authServiceProvider` | Provider<AuthService> | Singleton AuthService instance |
| `firestoreServiceProvider` | Provider<FirestoreService> | Singleton FirestoreService instance |
| `authStateChangesProvider` | StreamProvider<User?> | Reactive Firebase auth state |
| `mockBypassLoginProvider` | NotifierProvider<bool> | Bypass login when Firebase isn't configured |
| `mockBypassUserProfileProvider` | NotifierProvider<UserModel?> | Mock user profile for bypass mode |
| `currentUserProfileProvider` | FutureProvider<UserModel?> | Current user's Firestore profile |

**Mock Bypass System**: When Firebase is not configured (common in development), the app automatically bypasses authentication and creates a guest user profile, allowing full access to all features.

#### 4.3.2 Gadget Providers (`lib/providers/gadget_provider.dart`)
| Provider | Type | Purpose |
|---|---|---|
| `gadgetsStreamProvider` | StreamProvider | All gadgets (Firestore → fallback to dummy) |
| `trendingGadgetsProvider` | StreamProvider | Trending gadgets only |
| `gadgetsByCategoryProvider` | StreamProvider.family | Gadgets filtered by category |
| `compareProvider` | NotifierProvider | Compare list state (max 3 gadgets) |
| `favoritesProvider` | NotifierProvider | Favorites/bookmarks state |

**Dummy Data Catalog** (10 gadgets across 6 categories):
1. Samsung Galaxy S24 Ultra (₹1,29,999)
2. Apple iPhone 15 Pro Max (₹1,59,900)
3. Google Pixel 8 Pro (₹1,06,999)
4. Apple MacBook Pro 14" (₹1,69,900)
5. ASUS ROG Zephyrus G16 (₹1,89,990)
6. Apple iPad Pro 11" (₹99,900)
7. Apple Watch Series 9 (₹41,900)
8. Samsung Galaxy Watch6 (₹29,999)
9. Sony WH-1000XM5 (₹29,990)
10. Amazon Echo Show 10 (₹24,999)

#### 4.3.3 AI Recommendation Provider (`lib/providers/ai_recommendation_provider.dart`)
| Provider | Type | Purpose |
|---|---|---|
| `geminiServiceProvider` | Provider<GeminiService> | Singleton Gemini service |
| `aiRecommendationProvider` | NotifierProvider | AI recommendation state + loading/error handling |

The `AiRecommendationNotifier` manages the full lifecycle:
1. Sets loading state
2. Fetches live gadgets from Firestore (falls back to dummy data)
3. Calls `GeminiService.getRecommendations()` with all parameters
4. Updates state with results or error

#### 4.3.4 Theme Provider (`lib/providers/theme_provider.dart`)
- Default theme: **Dark Mode**
- Toggle between `ThemeMode.light` and `ThemeMode.dark`

---

### 4.4 Screens (UI Pages)

#### 4.4.1 HomeScreen (`lib/screens/home_screen.dart`) — Main Landing Page
**Features:**
- **Animated Mesh Gradient Hero Section**: Custom `MeshGradientAnimation` widget with 4 oscillating color blobs created using `CustomPainter` and `AnimationController`
- **Glassmorphism Overlay**: Semi-transparent decorative circles with blur effects
- **"AI-Powered Recommendations" Badge**: Floating label with amber sparkle icon
- **Hero Text**: "Discover Your Next Perfect Gadget" in Outfit font (42px, w900)
- **"Start Exploring" CTA Button**: Navigates to recommendation form
- **Browse Categories Grid**: 6 categories (Smartphones, Laptops, Smart Watches, Tablets, Headphones, Smart Home) with animated hover effects, responsive grid (3 or 6 columns)
- **Trending Gadgets Carousel**: Horizontal scrollable list of trending gadget cards with real product images
- **Floating Compare Button**: Appears when gadgets are added to comparison
- **Theme Toggle**: Animated rotation transition between sun/moon icons
- **User Avatar**: Profile picture in AppBar with navigation to profile

**UI Techniques Used:**
- `BackdropFilter` for frosted glass AppBar
- `AnimatedContainer` for hover state transitions
- `AnimatedScale` for category item hover zoom
- `MouseRegion` for desktop hover detection
- `LayoutBuilder` for responsive grid column count

#### 4.4.2 AuthScreen (`lib/screens/auth_screen.dart`) — Login/Registration
- Toggle between **Sign In** and **Create Account** modes
- Email, Password, and Name (signup only) text fields
- Primary action button with loading state
- Google Sign-In button (outlined style)
- **Fallback**: If Firebase fails, automatically creates a guest bypass session

#### 4.4.3 RecommendationFormScreen (`lib/screens/recommendation_form_screen.dart`) — Preference Input
**Form Sections:**
1. **Core Preferences**: Gadget Type dropdown, Primary Usage dropdown, Budget slider (₹5,000 – ₹3,00,000), Preferred Brand text field
2. **Technical Specs**: Minimum RAM dropdown (4GB–64GB), Minimum Storage dropdown (64GB–2TB)
3. **Experience**: Camera Priority dropdown (Does not matter → Excellent Pro), Battery Life dropdown (Does not matter → Multi-day)

**UI Details:**
- Cards with section headers and dividers
- Indian Rupee formatting with comma separators (₹1,50,000)
- Slider with custom thumb and track styling
- "Generate Recommendations" button with loading spinner

#### 4.4.4 RecommendationResultsScreen (`lib/screens/recommendation_results_screen.dart`) — AI Results
**Displays:**
- Match cards ranked #1 through #5
- Device image (from GSMArena CDN via CORS proxy or assets)
- Name, brand, price with ₹ formatting
- Key feature chips (top 3 features)
- AI explanation in an italicized note box with sparkle icon
- "View Details" and "Compare" action buttons per card
- Loading state: "Analyzing specs and expert reviews..."
- Error state: "AI Consultation Failed" with retry
- Empty state: "No perfect matches found"

**Compare Integration:**
- Creates `GadgetModel` from AI results for comparison
- Auto-navigates to comparison screen when 2+ gadgets selected

#### 4.4.5 DetailsScreen (`lib/screens/details_screen.dart`) — Gadget Detail View
**Layout:**
- `SliverAppBar` with 400px expandable hero image
- `Hero` animation tag for smooth transitions from list
- Brand name in uppercase with primary color
- Product name (32px Outfit bold)
- Price with comma formatting and star rating
- **Overview** section with description
- **Technical Specifications** grid (2-column) with labeled spec cards
- **Actions Row**: Compare button + Favorite heart button
- **User Insights**: Review list or "No analyst reviews" placeholder
- **"You Might Also Like"**: Horizontal scroll of same-category gadgets

**Data Source Priority:**
1. AI recommendation results (from provider state)
2. Firestore gadgets stream
3. Trending gadgets provider
4. Dummy gadgets fallback

#### 4.4.6 ComparisonScreen (`lib/screens/comparison_screen.dart`) — Side-by-Side Comparison
- Supports up to 3 gadgets simultaneously
- Label column with 16 comparison fields: Brand, Price, Rating, Network, Launch, Body, Display, Platform, Memory, Main Camera, Selfie Camera, Sound, Comms, Features, Battery, Misc
- Product image, name, and price header for each column
- Remove button (×) per gadget
- "Clear All" action in AppBar
- Horizontal and vertical scrolling for overflow content
- Empty state with "No gadgets selected" message

#### 4.4.7 CategoriesScreen (`lib/screens/categories_screen.dart`) — Category Browser
- Sidebar navigation (260px wide) with category list
- Animated selection highlighting with primary color
- Category icons for each type
- Breadcrumb trail (CATEGORIES > SMARTPHONES)
- Responsive grid of gadget cards
- Real-time data from Firestore with loading/error states

#### 4.4.8 FavoritesScreen (`lib/screens/favorites_screen.dart`)
- Grid view of favorited gadgets
- Resolves favorites from multiple sources (Firestore stream, trending, dummy data)
- Fallback "AI Saved Item" placeholder for unrecognized IDs
- Empty state with heart icon and "Browse Gadgets" CTA

#### 4.4.9 ProfileScreen (`lib/screens/profile_screen.dart`)
- User avatar (CircleAvatar with network image)
- Display name and email
- Settings card with Dark Mode toggle switch
- "My Favorites" navigation link
- "Log Out" button

#### 4.4.10 AdminDashboard (`lib/screens/admin_dashboard.dart`)
- Placeholder screen ("Admin Dashboard (WIP)")
- Reserved for future admin functionality

---

### 4.5 Reusable Widgets

#### 4.5.1 GadgetCard (`lib/widgets/gadget_card.dart`)
Premium product card with:
- **Glassmorphism rating badge** (top-right): `BackdropFilter` blur with semi-transparent overlay
- **Glassmorphism favorite button** (top-left): Heart icon with toggle
- **Hover animation**: `AnimatedScale` 1.02x zoom on mouse enter
- **Gradient background**: LinearGradient from surface colors
- **Hero image**: Supports both asset and network images with loading/error builders
- **Info section**: Brand (uppercase, primary color), Name, Price (₹ formatted), Compare toggle button
- **Image placeholder**: Category-specific icon in circular container with brand text

#### 4.5.2 MeshGradientAnimation (`lib/widgets/mesh_gradient.dart`)
Custom animated background widget:
- `SingleTickerProviderStateMixin` with 10-second looping `AnimationController`
- `CustomPainter` (`_MeshPainter`) draws:
  - Base background rectangle using primary color
  - Multiple radial gradient "blobs" that oscillate in circular paths
  - Uses `cos()` and `sin()` with offset phases for organic movement
- Colors derived from theme's primary, tertiary, secondary, and surface colors

#### 4.5.3 SpecChip (`lib/widgets/spec_chip.dart`)
Compact specification display chip:
- Label text (10px, hint color, bold)
- Value text (12px, w600)
- Optional leading icon
- Rounded container with surface color background and subtle border

#### 4.5.4 TechButton (`lib/widgets/tech_button.dart`)
Styled action button with two variants:
- **Primary**: Elevated button with primary color background
- **Secondary**: Outlined button with primary color border
- Loading state: Replaces text with `CircularProgressIndicator`
- Optional leading icon

---

### 4.6 Theming System (`lib/utils/theme.dart`)

**Brand Colors:**
| Color | Hex | Name |
|---|---|---|
| Primary | #6366F1 | Indigo |
| Secondary | #EC4899 | Pink |
| Accent | #8B5CF6 | Violet |

**Dark Palette (Default):**
| Color | Hex | Usage |
|---|---|---|
| Background | #09090B | Scaffold background |
| Surface | #18181B | Cards, dialogs |
| Border | #27272A | Dividers, borders |

**Light Palette:**
| Color | Hex | Usage |
|---|---|---|
| Background | #FAFAFA | Scaffold background |
| Surface | #FFFFFF | Cards, dialogs |
| Border | #E4E4E7 | Dividers, borders |

**Typography:**
- Body text: **Google Fonts Inter** — Clean, modern sans-serif
- Headings: **Google Fonts Outfit** — Bold, geometric display font

**Material 3:** Fully enabled with `useMaterial3: true` and `ColorScheme.fromSeed()`

---

### 4.7 Routing (`lib/utils/router.dart`)

**Route Definitions:**
| Path | Screen | Description |
|---|---|---|
| `/login` | AuthScreen | Login/Signup page |
| `/` | HomeScreen | Main landing page |
| `/categories` | RecommendationFormScreen | Category browsing |
| `/recommend` | RecommendationFormScreen | Recommendation form (accepts `extra` for initial category) |
| `/results` | RecommendationResultsScreen | AI recommendation results |
| `/compare` | ComparisonScreen | Side-by-side comparison |
| `/details/:id` | DetailsScreen | Gadget detail view (parameterized) |
| `/profile` | ProfileScreen | User profile & settings |
| `/admin` | AdminDashboard | Admin panel |
| `/favorites` | FavoritesScreen | Saved/bookmarked gadgets |

**Authentication Guard:**
- Redirects unauthenticated users to `/login`
- Redirects authenticated users away from `/login` to `/`
- Supports mock bypass mode for development/demo

---

## 5. CI/CD PIPELINE & DEPLOYMENT

### 5.1 GitHub Actions Workflow (`.github/workflows/deploy.yml`)

**Trigger:** Push to `main` branch

**Job 1: Build & Push** (ubuntu-latest)
1. Checkout code
2. Setup Flutter (stable channel, cached)
3. Create `.env` file from GitHub Secrets (`GEMINI_API_KEY`)
4. `flutter pub get`
5. `flutter build web --release --no-tree-shake-icons`
6. Login to Docker Hub
7. Build Docker image and push to Docker Hub

**Job 2: Deploy** (ubuntu-latest, depends on Job 1)
1. SSH into AWS EC2 instance
2. Create/update `compose.yaml` on server
3. `docker pull` latest image
4. `docker compose down` (stop old)
5. `docker compose up -d` (start new)
6. `docker image prune -f` (cleanup)

### 5.2 Docker Configuration

**Dockerfile:**
```dockerfile
FROM nginx:alpine
COPY build/web /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Nginx Configuration (`nginx/nginx.conf`):**
- SPA routing: All routes serve `index.html` (for client-side routing)
- Static asset caching: 30-day expiry for JS, CSS, images, fonts
- Error page handling for 5xx errors

**Docker Compose (`compose.yaml`):**
```yaml
version: "3.8"
services:
  smart-gadget-web:
    image: akhi1babu/smart-gadget-flutter:latest
    container_name: smart-gadget-app
    restart: unless-stopped
    ports:
      - "80:80"
    networks:
      - webnet
```

### 5.3 Production URL
- **AWS EC2 Public IP:** `http://13.206.34.74`

### 5.4 GitHub Repository
- **URL:** `https://github.com/aroma1u/smart_gadget_recommendation`
- **Branch:** `main`
- **Docker Hub Image:** `akhi1babu/smart-gadget-flutter:latest`

---

## 6. APPLICATION CONSTANTS

### 6.1 Gadget Categories
1. Smartphones
2. Laptops
3. Smart Watches
4. Tablets
5. Headphones
6. Smart Home

### 6.2 User Usage Options
1. Gaming
2. Photography
3. Daily use
4. Video editing
5. Programming
6. Office work

---

## 7. SECURITY CONSIDERATIONS

### 7.1 API Key Management
- Gemini API key stored in `.env` file
- `.env` is listed in `.gitignore` — never committed to version control
- In CI/CD, the API key is injected from GitHub Secrets at build time
- The API key is baked into the Flutter web build as a bundled asset

### 7.2 Authentication Security
- Gmail-only account restriction (`@gmail.com`)
- Non-Gmail Google accounts are automatically deleted from Firebase Auth
- Mock bypass mode for demo/development only — not for production use

### 7.3 CORS Handling
- Device images from GSMArena CDN require CORS proxy for Flutter Web
- Uses `images.weserv.nl` as a free, reliable CORS proxy
- Fallback Unsplash image URLs provided as safe defaults

---

## 8. USER FLOW

### 8.1 Main User Journey
```
1. Open App → Login Screen
2. Sign in (Email/Password or Google, or Guest bypass)
3. Home Screen → Browse categories / View trending gadgets
4. Click "Start Exploring" or select a category
5. Recommendation Form → Fill preferences (category, budget, brand, usage, specs)
6. Click "Generate Recommendations"
7. AI analyzes preferences against catalog + latest market knowledge
8. Results Screen → View top 5 AI-matched gadgets
9. View Details → Full spec sheet for a device
10. Compare → Add devices to comparison (up to 3)
11. Favorites → Bookmark devices for later
12. Profile → Toggle theme, manage favorites, logout
```

### 8.2 AI Recommendation Flow
```
User Input → GeminiService.getRecommendations()
  ├── If no API key → Return mock data (3 dummy recommendations)
  └── If API key present:
      ├── Fetch live gadgets from Firestore (fallback: dummy data)
      ├── Filter catalog by selected category
      ├── Construct AI prompt with:
      │   ├── User preferences (8 parameters)
      │   ├── Available catalog data
      │   └── Output format instructions (JSON schema)
      ├── Send to Gemini 2.5 Flash API
      ├── Parse JSON response
      ├── Build image URLs from GSMArena slugs
      ├── Pad to 5 results if needed (from catalog fallback)
      └── Return List<Map<String, dynamic>>
```

---

## 9. COMPLETE SOURCE CODE LISTING

### 9.1 File Statistics

| Directory | Files | Total Lines | Total Size |
|---|---|---|---|
| `lib/` (root) | 1 | 50 | 1.5 KB |
| `lib/models/` | 2 | 118 | 3.1 KB |
| `lib/services/` | 3 | 405 | 16.9 KB |
| `lib/providers/` | 4 | 401 | 11.1 KB |
| `lib/screens/` | 10 | 2,357 | 92.6 KB |
| `lib/widgets/` | 4 | 571 | 19.7 KB |
| `lib/utils/` | 3 | 279 | 9.2 KB |
| **Total Dart source** | **27 files** | **~4,181 lines** | **~154 KB** |

### 9.2 Configuration Files

| File | Purpose |
|---|---|
| `pubspec.yaml` | Flutter dependencies and assets |
| `.env` | Environment variables (GEMINI_API_KEY) |
| `.gitignore` | Git ignore rules (includes .env) |
| `Dockerfile` | Docker build instructions |
| `compose.yaml` | Docker Compose service definition |
| `nginx/nginx.conf` | Nginx reverse proxy config |
| `.github/workflows/deploy.yml` | CI/CD pipeline definition |
| `analysis_options.yaml` | Dart linting rules |

---

## 10. KEY FEATURES SUMMARY

| # | Feature | Status |
|---|---|---|
| 1 | AI-Powered Gadget Recommendations (Gemini 2.5 Flash) | ✅ Implemented |
| 2 | User Authentication (Email/Password + Google Sign-In) | ✅ Implemented |
| 3 | Comprehensive Gadget Catalog (10 products, 6 categories) | ✅ Implemented |
| 4 | Category Browsing with Sidebar Navigation | ✅ Implemented |
| 5 | Side-by-Side Comparison (up to 3 gadgets) | ✅ Implemented |
| 6 | Favorites/Bookmarking System | ✅ Implemented |
| 7 | Gadget Detail View with Full Specs | ✅ Implemented |
| 8 | Dark/Light Theme Toggle | ✅ Implemented |
| 9 | Animated Mesh Gradient Hero Section | ✅ Implemented |
| 10 | Glassmorphism UI Effects | ✅ Implemented |
| 11 | Responsive Web Layout | ✅ Implemented |
| 12 | Docker Containerization | ✅ Implemented |
| 13 | CI/CD with GitHub Actions | ✅ Implemented |
| 14 | AWS EC2 Production Deployment | ✅ Implemented |
| 15 | Mock/Guest Bypass for Demo Mode | ✅ Implemented |
| 16 | GSMArena Image Integration (CORS Proxy) | ✅ Implemented |
| 17 | Admin Dashboard | 🔄 Work in Progress |

---

## 11. FUTURE ENHANCEMENTS

1. **Full Admin Panel**: CRUD operations for gadgets, user management, analytics dashboard
2. **Search Functionality**: Global search across all gadgets with filters
3. **Price History Tracking**: Historical price charts and deal alerts
4. **User Reviews**: Allow authenticated users to submit reviews and ratings
5. **Push Notifications**: Web push notifications for price drops and new arrivals
6. **PWA Support**: Progressive Web App with offline capabilities
7. **Multi-language Support**: Internationalization (i18n)
8. **Analytics Dashboard**: Usage metrics, popular searches, recommendation accuracy tracking
9. **Social Sharing**: Share gadget details and comparisons
10. **Wishlist Notifications**: Notify when wishlisted gadgets go on sale

---

## 12. CONCLUSION

Nexara is a comprehensive, production-ready Flutter Web application that demonstrates the successful integration of generative AI (Google Gemini 2.5 Flash) with modern web development practices. The project showcases advanced Flutter concepts including reactive state management with Riverpod, custom animations with CustomPainter, glassmorphism UI design, Firebase authentication and Firestore database integration, Docker containerization, and fully automated CI/CD deployment to AWS EC2. The application provides genuine value to users by simplifying the gadget discovery and comparison process through intelligent AI-powered personalized recommendations.

---

*Document generated on: March 13, 2026*
*Project Repository: https://github.com/aroma1u/smart_gadget_recommendation*
*Production URL: http://13.206.34.74*
