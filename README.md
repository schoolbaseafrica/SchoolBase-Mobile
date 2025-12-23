# SchoolBase 📚

Welcome to **SchoolBase**, your friendly neighborhood school attendance management app! Built with Flutter, this app makes tracking student attendance as easy as a tap. Whether you're an admin managing the system or a gateman scanning cards at the gate, SchoolBase keeps everything organized and secure.

## 🌟 What Makes SchoolBase Special?

SchoolBase is designed to simplify school attendance with modern technology. Using NFC cards, students can check in and out effortlessly, while admins and gate staff have the tools they need to manage everything smoothly.

### Key Features
- **🔐 Secure Authentication**: Login with your email and password to access role-specific features.
- **👥 Role-Based Access**: Different dashboards for admins and gatemen – everyone sees what they need.
- **📱 NFC Card Scanning**: Tap to check in or out. It's quick, contactless, and reliable.
- **📊 Attendance Tracking**: View real-time attendance records and history.
- **🛠️ Admin Tools**: Register and manage NFC cards for students and staff.
- **📶 Offline Support**: Works even without internet – data syncs when connected.
- **🎨 Clean UI**: Intuitive design with a red theme that's easy on the eyes.

## 🚀 Getting Started

Ready to get SchoolBase up and running? Follow these simple steps!

### Prerequisites
- Flutter SDK (version 3.10.1 or higher)
- Dart SDK (included with Flutter)
- An Android or iOS device with NFC support (for full functionality)

### Installation
1. **Clone the repository**:
   ```bash
   git clone https://github.com/schoolbaseafrica/SchoolBase-Mobile.git
   cd school_base
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

That's it! The app will launch on your connected device or emulator.

### Building for Production
- **Android APK**:
  ```bash
  flutter build apk --release
  ```
- **iOS**:
  ```bash
  flutter build ios --release
  ```

## 📖 How to Use SchoolBase

### For Admins
1. Log in with your admin credentials.
2. Use the dashboard to register new NFC cards.
3. Monitor attendance records and manage the system.

### For Gatemen
1. Log in as a gateman.
2. Switch between "Check-In" and "Check-Out" modes.
3. Scan NFC cards as students arrive or leave.
4. View attendance history on the History tab.

### For Students
- Just tap your NFC card when prompted. No app needed on your side!

## 🛠️ Technologies Under the Hood

SchoolBase is built with love using:
- **Flutter**: For cross-platform magic
- **Dart**: The language that makes it all happen
- **Provider**: State management that's as smooth as butter
- **NFC Manager**: For seamless card scanning
- **SQLite**: Local database for offline awesomeness
- **HTTP**: For syncing data when online

## 🤝 Contributing

We'd love your help to make SchoolBase even better! Here's how you can contribute:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-idea`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-idea`)
5. Open a Pull Request

Please make sure your code follows our style guidelines and includes tests where appropriate.

## 📄 License

This project is private and not licensed for public use.

## 📞 Support

Having trouble? Found a bug? Reach out to our support team or open an issue on GitHub.

dumebinwankwo87@gmail.com

Made with ❤️ for schools everywhere. Happy attending!
