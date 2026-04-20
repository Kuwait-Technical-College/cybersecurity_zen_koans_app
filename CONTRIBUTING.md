# Contributing to Cybersecurity Zen Koans App

Thank you for your interest in contributing! This app was created by **ktech Students** and we welcome all kinds of contributions, from app development to curating Zen koans.

To get started with open source contributions, check out the [ktech Contribute to Open Source](https://github.com/Kuwait-Technical-College/contribute_to_open_source) guide.

## 🚀 Option 1: Contribute to App Features

If you're a developer and want to help improve the app:

1. Fork the repo and clone it locally.
2. Set up the development environment (see [README](./README.md)). The Flutter project is in the `src/` directory.
3. Check out open issues labeled `feature`, `bug`, or `enhancement`.
4. Create a branch, make your changes, and submit a pull request.

Please write meaningful commit messages and keep changes focused.

## 🧘 Option 2: Add or Update Zen Koans

Want to improve the Zen experience? You can:

- Add new koans (koan text and the technical explanation of the koan)
- Fix typos or update existing koans

Koans are stored in [koans.json](./src/assets/koans.json). To add a new koan:

1. Open [koans.json](./src/assets/koans.json)
2. Add a new entry at the end of the array with the following format:
   ```json
   {
     "koanText": "Your koan text here",
     "technicalExplanation": "The technical cybersecurity explanation",
     "uniqueCode": "A6B2C3"
   }
   ```
   Use a unique 6-character alphanumeric code that doesn't already exist in the file.
3. Submit a pull request.

## 🙏 General Guidelines

- Be respectful and open-minded.
- Write clear pull request titles and descriptions.
- Link related issues when possible.

## 📬 Need Help?

Open an issue or reach out via GitHub Discussions.

Happy hacking and zen-writing!
