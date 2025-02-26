# Banter iOS - Development TODO List

- [ ] Внедрить MessageKit для чата и списка чатов [#2](/../../issues/2)
  - Вместо прямого доступа к Web3 использовать протоколы 
    - `ChatRepository` 
    - `MessageRepository`
- [ ] Архитектура: Изолировать работу с web3 в слой инфраструктуры [#3](/../../issues/3)
- [ ] Архитектура: Внедрить координатор с DI [#4](/../../issues/4)

## Cursor suggestions

### High Priority

#### Architecture & Core Implementation
- [ ] Implement proper error handling in blockchain transactions (currently only prints errors)
- [ ] Add retry mechanism for failed blockchain operations
- [ ] Implement proper state management for chat operations
- [ ] Add input validation for wallet addresses
- [ ] Create a dependency injection container
- [ ] Implement proper loading states during blockchain operations
- [ ] Add offline message queue support
- [ ] Implement proper transaction receipt handling
- [ ] Add gas price optimization strategy

#### Security
- [ ] Implement secure key storage using Keychain
- [ ] Add encryption for local message storage
- [ ] Implement proper wallet connection security
- [ ] Add transaction signing confirmation UI
- [ ] Implement session management
- [ ] Add biometric authentication option

#### Data Management
- [ ] Implement local caching for messages
- [ ] Add proper pagination for chat messages
- [ ] Implement message sync mechanism
- [ ] Add proper error states for failed message delivery
- [ ] Implement message status tracking (sent, delivered, read)

### Medium Priority

#### User Experience
- [ ] Add loading indicators for blockchain operations
- [ ] Implement pull-to-refresh for chat lists
- [ ] Add proper empty states for all views
- [ ] Implement proper keyboard handling
- [ ] Add haptic feedback for important actions
- [ ] Implement message composition state preservation
- [ ] Add support for message drafts

#### Testing
- [ ] Add unit tests for blockchain operations
- [ ] Implement UI tests for critical paths
- [ ] Add integration tests for chat operations
- [ ] Create mock services for testing
- [ ] Add performance tests for message handling
- [ ] Implement contract interaction tests

#### Monitoring & Debugging
- [ ] Add proper logging system
- [ ] Implement crash reporting
- [ ] Add analytics for user interactions
- [ ] Implement performance monitoring
- [ ] Add network request logging
- [ ] Create debugging tools for blockchain operations

### Lower Priority

#### Features
- [ ] Add support for message reactions
- [ ] Implement chat groups
- [ ] Add file sharing capabilities
- [ ] Implement user profiles
- [ ] Add message search functionality
- [ ] Implement chat backup/restore
- [ ] Add support for multiple wallet connections

#### Accessibility
- [ ] Add VoiceOver support
- [ ] Implement Dynamic Type
- [ ] Add accessibility labels
- [ ] Support reduced motion
- [ ] Implement high contrast support

#### Documentation
- [ ] Create API documentation
- [ ] Add inline code documentation
- [ ] Create architecture diagrams
- [ ] Document setup procedures
- [ ] Add contribution guidelines
- [ ] Create user documentation

#### Infrastructure
- [ ] Set up CI/CD pipeline
- [ ] Add automated code quality checks
- [ ] Implement automated deployment
- [ ] Add version management
- [ ] Create development environment configuration
- [ ] Set up proper staging environment

#### Code Quality
- [ ] Add SwiftLint configuration
- [ ] Implement SwiftFormat
- [ ] Add pre-commit hooks
- [ ] Create code style guide
- [ ] Implement code review guidelines

### Technical Debt
- [ ] Refactor CreateChat implementation to use async/await
- [ ] Improve error handling in infrastructure layer
- [ ] Optimize blockchain interaction patterns
- [ ] Refactor Chat model to include more metadata
- [ ] Implement proper MVVM architecture in all scenes
- [ ] Add proper dependency management
- [ ] Clean up unused code and resources

### Future Considerations
- [ ] Implement Layer 2 scaling solutions
- [ ] Add support for multiple blockchain networks
- [ ] Implement cross-chain messaging
- [ ] Add support for ENS names
- [ ] Implement token-gated chats
- [ ] Add support for smart contract upgrades
- [ ] Implement social recovery options 