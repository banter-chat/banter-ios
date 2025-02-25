# Banter iOS

## Overview
Banter iOS is a native Web3 chat application that enables users to communicate via blockchain technology. The app provides a simple and intuitive interface for chatting with others using blockchain wallet addresses.

## Features
- Web3 chat functionality 
- Chat list management
- Settings configuration
- Blockchain integration for messaging
- Dark/Light mode support

## Architecture
The project is organized according to Clean Architecture principles:
- **Domain**: Contains the core business models (Chat)
- **Scenes**: UI components organized by feature (Chat, ChatList, Settings)
- **Infrastructure**: Implementation of use cases (CreateChat, GetChats, GetMessages, SendMessage, Settings)
- **ABI**: Blockchain contract interfaces

## Technologies
- Swift & SwiftUI for UI development
- iOS 17.5+ target
- Navigation with NavigationStack
- Blockchain integration for Web3 messaging

## Setup Instructions

### Requirements
- Xcode 16.0 or higher
- iOS 17.5+ deployment target
- Swift 6.0+

### Installation
1. Clone the repository:
```
git clone https://github.com/your-organization/banter-ios.git
cd banter-ios
```

2. Open the project in Xcode:
```
open Banter.xcodeproj
```

3. Build and run the application on a simulator or device

## Development Workflow

### Coding Standards
- Follow the Swift style guide
- Use SwiftUI for new UI components where possible
- Implement MVVM pattern consistently
- Write unit tests for new features

### Testing
- Unit tests for business logic and view models
- Snapshot tests for UI components
- Integration tests for service communication

### Branching Strategy
We use trunk-based development:
- Make changes in a feature branch
- Create a Pull Request to `main`
- Use squash merge when integrating into `main`

## Backend Integration
The iOS app uses blockchain technology for its messaging capabilities. Messages are stored and transmitted through blockchain contracts.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details. 