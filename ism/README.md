# ISM - Interactive Student Management

![Flutter](https://img.shields.io/badge/Flutter-3.2+-02569B?logo=flutter)
![Riverpod](https://img.shields.io/badge/State-Riverpod-purple)
![Firebase](https://img.shields.io/badge/Backend-Firebase-orange?logo=firebase)

An engaging educational mobile app for high school students (ages 17-18) that teaches the fundamentals of Economics, Management, Business, and Marketing through gamification, interactive scenarios, and real-world connections. Built as a marketing tool for ISM University.

---

## 🎯 Core Concept: "Build Your Business Empire"

Students create and grow a virtual business while learning through **The Four Pillars**:
- 📊 **Economics Tower** - Supply/demand, market structures, micro/macro economics
- 🎯 **Management Building** - Leadership, team dynamics, project management
- 💼 **Business Center** - Business models, finance, ethics, entrepreneurship
- 📱 **Marketing Hub** - 4Ps, digital marketing, consumer behavior, branding

---

## ✨ Key Features

### 🎮 Gamification
- **50 Levels** with progression-based unlocks
- **XP & Currency System** (ISM Coins + Knowledge Gems)
- **60+ Achievement Badges** across all categories
- **Business Growth Meter** tracking startup → corporation journey
- **Daily Rewards & Login Streaks**

### 🎓 Educational Content
- **40+ Interactive Lessons** across four subject areas
- **Mini-Games** for each pillar (Market Matcher, Team Builder, Budget Boss, Brand Battle)
- **Interactive Quizzes** (multiple choice, drag-and-drop, scenarios)
- **Major Simulation**: 30-day "Your Business Journey" simulation
- **Real-World Connections**: Business news feed, company spotlights, economic indicators

### 👥 Social Features
- **Global & Friends Leaderboards**
- **Weekly Challenges & Competitions**
- **Co-op Challenges** - team up with friends
- **VS Mode** - head-to-head quiz battles
- **Achievement Sharing** on social media

### 🎨 Personalization
- **Avatar Customization** (100+ unlockable items)
- **Business Customization** (choose industry, design office, create logo)
- **Learning Preferences** (difficulty, content format, pacing)
- **Theme Selection** + Dark Mode
- **Adaptive Content** based on learning style quiz

### 🏫 ISM University Integration
- **Success Stories**: 20+ video interviews with ISM students/alumni
- **Virtual Campus Tours**: 360° interactive tours (unlocked through progress)
- **Career Pathways**: Visualizations linking education to careers
- **Application Hub** (Level 25+): Scholarship info, application tips, direct apply link
- **ISM Insider Content**: Student vlogs, professor spotlights, event invitations

### 📱 Technical Features
- **Offline Support**: Download lessons, cache content, offline quizzes
- **Progress Tracking**: Detailed analytics dashboard, weekly reports
- **Dark Mode**: Auto/manual toggle, optimized for reading
- **Multi-Language**: English, Lithuanian (+ future: Russian, Polish, Spanish, German)
- **Accessibility**: Screen reader, adjustable fonts, high contrast, colorblind modes
- **Push Notifications**: Customizable reminders, friend activity, new content

### 🏆 Rewards & Unlockables
- **Certificates**: Subject mastery + overall completion (shareable on LinkedIn)
- **Milestone Rewards**:
  - Level 10: First campus tour + 500 coins
  - Level 25: Application Hub + exclusive avatar
  - Level 40: Premium success stories + 1000 coins
  - Level 50: Official ISM certificate (digital + physical option)
- **Exclusive Content**: ISM Insider articles, professor lectures, alumni networking

---

## 🏗️ Technical Architecture

### Tech Stack
- **Framework**: Flutter 3.2+ (Cross-platform iOS/Android)
- **State Management**: Riverpod 2.4+ with code generation
- **Backend**: Firebase (Auth, Firestore, Storage, Cloud Functions, Analytics, Messaging)
- **Local Storage**: Hive + Shared Preferences
- **Navigation**: GoRouter
- **Video**: video_player package
- **360° Tours**: panorama_viewer package
- **Charts**: fl_chart
- **Internationalization**: flutter_localizations

### Project Structure
```
lib/
├── core/
│   ├── constants/        # App constants, API keys, strings
│   ├── routing/          # GoRouter configuration
│   ├── theme/            # Theme, colors, text styles
│   └── utils/            # Helper functions, extensions
├── features/
│   ├── onboarding/       # Avatar creation, business selection, tutorial
│   ├── economics/        # Economics Tower lessons & games
│   ├── management/       # Management Building lessons & games
│   ├── business/         # Business Center lessons & games
│   ├── marketing/        # Marketing Hub lessons & games
│   ├── profile/          # User profile, progress, achievements
│   ├── leaderboard/      # Social features, rankings, challenges
│   ├── simulation/       # 30-day business simulation
│   └── shared/           # Shared widgets across features
├── models/               # Data models (Freezed)
├── providers/            # Riverpod providers
├── services/             # Firebase, API, local storage services
└── widgets/              # Reusable UI components

assets/
├── images/               # Icons, avatars, backgrounds
├── videos/               # Tutorial videos, success stories
└── animations/           # Lottie animations

test/
├── unit/                 # Unit tests
├── widget/               # Widget tests
└── integration/          # Integration tests
```

### State Management Pattern (Riverpod)
```dart
// Example: User progress provider
@riverpod
class UserProgress extends _$UserProgress {
  @override
  Future<UserProgressModel> build() async {
    final service = ref.watch(userServiceProvider);
    return service.getUserProgress();
  }

  Future<void> addXP(int amount) async {
    final current = await future;
    final updated = current.copyWith(xp: current.xp + amount);
    state = AsyncValue.data(updated);
    await ref.read(userServiceProvider).saveProgress(updated);
  }
}
```

---

## 🚀 Development Roadmap

### Phase 1: MVP (3-4 months)
- [ ] Onboarding flow + avatar creation
- [ ] Economics Tower (10 lessons, 2 mini-games)
- [ ] Basic quiz system
- [ ] Progress tracking dashboard
- [ ] Dark mode
- [ ] Offline lesson support
- [ ] Firebase integration (Auth, Firestore)

### Phase 2: Complete Content (2-3 months)
- [ ] Management Building (10 lessons, 2 mini-games)
- [ ] Business Center (10 lessons, 2 mini-games)
- [ ] Marketing Hub (10 lessons, 2 mini-games)
- [ ] Social features (leaderboards, friends, challenges)
- [ ] ISM content (5 success stories, 2 campus tours)
- [ ] Achievement system (60+ badges)

### Phase 3: Advanced Features (2 months)
- [ ] 30-day business simulation
- [ ] Real-world news feed integration
- [ ] Application Hub (scholarships, tips, direct apply)
- [ ] Multi-language support (English, Lithuanian)
- [ ] Multiplayer modes (co-op, VS mode)
- [ ] Career pathways visualization

### Phase 4: Polish & Launch (1 month)
- [ ] Comprehensive testing (unit, widget, integration)
- [ ] Performance optimization
- [ ] Analytics implementation
- [ ] App Store & Play Store setup
- [ ] Marketing materials
- [ ] Beta testing with high school students
- [ ] Launch campaign

### Phase 5: Post-Launch (Ongoing)
- [ ] User feedback implementation
- [ ] Additional ISM content (new success stories, tours)
- [ ] Seasonal events & challenges
- [ ] New languages (Russian, Polish, Spanish, German)
- [ ] AR campus tour feature
- [ ] Advanced analytics & A/B testing

---

## 📋 Getting Started

### Prerequisites
- Flutter SDK 3.2 or higher
- Dart 3.0 or higher
- Firebase account and project setup
- Android Studio / Xcode for mobile development

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ism.git
   cd ism
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation** (for Riverpod, Freezed, JSON)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure Firebase**
   - Create a Firebase project
   - Add Android/iOS apps to Firebase
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place in respective platform directories
   - Update `lib/core/constants/firebase_options.dart`

5. **Run the app**
   ```bash
   flutter run
   ```

### Development Commands

```bash
# Run code generation in watch mode
flutter pub run build_runner watch --delete-conflicting-outputs

# Run tests
flutter test

# Run with specific flavor (dev/staging/prod)
flutter run --flavor dev -t lib/main_dev.dart

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ios --release

# Analyze code
flutter analyze

# Format code
dart format .
```

---

## 🎨 Design Guidelines

### Color Palette
- **Primary**: ISM University brand colors (TBD)
- **Secondary**: Energetic accent colors for gamification
- **Success**: Green for achievements
- **Warning**: Yellow for challenges
- **Error**: Red for incorrect answers
- **Dark Mode**: Deep blues and purples with high contrast

### Typography
- **Font Family**: Poppins (Google Fonts)
- **Headings**: Bold (700), Semi-Bold (600)
- **Body**: Regular (400), Medium (500)
- **Display**: Large headings for key moments

### UI/UX Principles
- **Mobile-First**: Optimized for thumb-friendly navigation
- **Microinteractions**: Animations for every action
- **Immediate Feedback**: Visual confirmation of all interactions
- **Progressive Disclosure**: Don't overwhelm, reveal features gradually
- **Achievement Celebration**: Big, satisfying animations for milestones

---

## 🧪 Testing Strategy

### Unit Tests
- Models, providers, services
- Business logic validation
- Data transformations

### Widget Tests
- Individual UI components
- Feature screens
- User interactions

### Integration Tests
- User flows (onboarding → lesson → quiz → reward)
- Firebase integration
- Offline/online sync

### Manual Testing
- Cross-device testing (iOS/Android, tablets)
- Accessibility testing
- Performance testing
- Usability testing with target audience (17-18 year olds)

---

## 📊 Analytics & Metrics

### Key Metrics to Track
- **Engagement**: Daily/Monthly Active Users, Session length, Retention rate
- **Learning**: Lessons completed, Quiz scores, Time per subject
- **Gamification**: XP earned, Levels reached, Achievements unlocked
- **Social**: Friends added, Challenges participated, Leaderboard ranking
- **Conversion**: ISM content views, Application Hub visits, Apply button clicks

### Analytics Tools
- Firebase Analytics (in-app behavior)
- Mixpanel (advanced user segmentation)
- Firebase Crashlytics (error tracking)

---

## 🌍 Internationalization

### Supported Languages
- **v1.0**: English, Lithuanian
- **Future**: Russian, Polish, Spanish, German

### Implementation
```dart
// Using Flutter's built-in i18n
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context)!.welcomeMessage)
```

All UI strings, lesson content, and ISM materials will be fully translated.

---

## 🔐 Security & Privacy

- **Firebase Authentication**: Secure user accounts
- **Data Encryption**: Sensitive data encrypted at rest
- **Privacy Policy**: GDPR/COPPA compliant (for teens)
- **Anonymous Usage**: Option to use app without account
- **Data Export**: Users can export their progress
- **Age Verification**: Confirm 13+ age for social features

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is proprietary and owned by ISM University. All rights reserved.

---

## 📞 Contact

**Project Lead**: [Your Name]
**ISM University**: [Contact Info]
**Email**: info@ism.lt
**Website**: https://www.ism.lt

---

## 🙏 Acknowledgments

- ISM University for sponsoring this educational initiative
- Flutter & Firebase teams for excellent frameworks
- The Riverpod community for state management guidance
- Beta testers and high school students for feedback

---

## 📱 Screenshots

_Coming soon after UI development_

---

## 🔄 Version History

### v1.0.0 (TBD)
- Initial release
- Four complete learning pillars
- 40+ lessons and mini-games
- Social features and leaderboards
- ISM content integration
- Offline support
- English and Lithuanian languages

---

**Built with ❤️ for future business leaders**
