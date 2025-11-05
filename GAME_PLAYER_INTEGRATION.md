# Game Player Integration Guide

## Overview

A complete player management system that stores **username**, **player ID**, and **optional profile image** for both players and hosts.

**Key Concept**: `username` = `playerId` (they are the same)

## Architecture

### Two Player Models (Separate & Independent)

1. **UserModel** (Freezed) - `lib/core/models/user/user_model.dart`
   - Used for Mash platform integration
   - Contains: id, phoneNumber, polarCustomerId
   - **NOT MODIFIED** - Kept intact for platform compatibility

2. **GamePlayerModel** (Simple Dart) - `lib/core/models/session/game_player_model.dart`
   - Used for game-specific player data
   - Contains: playerId, username, profileImage (optional), timestamps
   - **NEW** - Clean, simple model for game players

### Storage Locations

1. **Local Storage** (via AppService)
   - Stores: playerId (username), profileImage path
   - Used for: Quick access, offline support

2. **Firestore** (via FirebaseFirestoreService)
   - Collection: `games/insan_jamd_hawan/game_players/{playerId}`
   - Stores: Complete GamePlayerModel
   - Used for: Cross-device sync, player lookup

## File Structure

```
lib/
├── core/
    ├── models/
    │   ├── session/
    │   │   └── game_player_model.dart (NEW - game player)
    │   └── user/
    │       └── user_model.dart (UNTOUCHED - Mash platform)
    ├── services/
    │   ├── cache/
    │   │   ├── helper.dart (UPDATED - added profile image methods)
    │   │   └── stored_keys.dart (UPDATED - added profileImage key)
    │   └── game_player_service.dart (NEW - player management)
    ├── db/
    │   └── firebase_firestore_service.dart (UPDATED - added player ops)
    └── controllers/
        └── player_info_controller.dart (UPDATED - saves profile image)
```

## Firestore Structure

```
firestore/
└── games/
    └── insan_jamd_hawan/
        ├── game_players/          (NEW collection)
        │   └── {playerId}/        (username as document ID)
        │       ├── playerId: "john_doe"
        │       ├── username: "john_doe"
        │       ├── profileImage: "path/to/image.jpg" (optional)
        │       ├── createdAt: Timestamp
        │       └── lastActive: Timestamp
        └── sessions/
            └── {sessionId}/
                └── ... (existing session structure)
```

## Usage Examples

### 1. Save Player Info (Registration/Setup)

```dart
import 'package:insan_jamd_hawan/core/services/game_player_service.dart';

// Save player with username and optional image
final player = await GamePlayerService.instance.savePlayerInfo(
  username: 'john_doe',
  profileImage: '/path/to/profile.jpg', // optional
);

print('Player ID: ${player.playerId}'); // same as username
print('Username: ${player.username}');
print('Image: ${player.profileImage}');
```

### 2. Get Current Player Info

```dart
// Get from local storage
final info = await GamePlayerService.instance.getCurrentPlayerInfo();
print('Username: ${info['username']}');
print('Player ID: ${info['playerId']}'); // same as username
print('Image: ${info['profileImage']}');

// Or get individual fields
final username = await GamePlayerService.instance.getCurrentUsername();
final image = await GamePlayerService.instance.getCurrentProfileImage();
```

### 3. Update Profile Image

```dart
await GamePlayerService.instance.updateProfileImage('/new/path/image.jpg');
```

### 4. Sync to Firestore (on Game Start)

```dart
// Ensures local player data is synced to Firestore
final player = await GamePlayerService.instance.syncLocalPlayerToFirestore();
if (player != null) {
  print('Player synced: ${player.username}');
}
```

### 5. Get Player from Firestore

```dart
import 'package:insan_jamd_hawan/core/db/firebase_firestore_service.dart';

final firestore = FirebaseFirestoreService.instance;
final player = await firestore.getGamePlayer('john_doe');
if (player != null) {
  print('Found player: ${player.username}');
  print('Image: ${player.profileImage}');
}
```

### 6. Update Last Active (During Gameplay)

```dart
// Call periodically during gameplay
await GamePlayerService.instance.updateLastActive();
```

### 7. Logout/Clear Data

```dart
await GamePlayerService.instance.clearPlayerData();
```

## Integration with Existing Code

### PlayerInfoController (Already Updated)

```dart
Future<void> savePlayerInfo(BuildContext context) async {
  final username = usernameController.text.trim();
  
  // Save username to local storage (username = playerId)
  await AppService.setPlayerId(username);
  
  // Save profile image if provided
  if (profileImagePath != null) {
    await AppService.setProfileImage(profileImagePath!);
  }
  
  // Optionally sync to Firestore immediately
  // await GamePlayerService.instance.syncLocalPlayerToFirestore();
}
```

### Lobby Creation (Recommended Integration)

```dart
Future<void> createLobby() async {
  // 1. Sync player to Firestore
  final player = await GamePlayerService.instance.syncLocalPlayerToFirestore();
  
  // 2. Create lobby with player info
  final lobby = await PlayflowClient.instance.createGameRoom(
    config: LobbyConfigModel(
      host: player?.playerId ?? 'unknown',
      // ... other config
    ),
  );
  
  // 3. Create Firestore session with player data
  final session = GameSessionModel(
    sessionId: lobby.id!,
    lobbyId: lobby.id!,
    hostId: player!.playerId,
    hostName: player.username,
    // ... other fields
  );
  
  await FirebaseFirestoreService.instance.createSession(session);
}
```

### Player Joining Lobby

```dart
Future<void> joinLobby(String code) async {
  // 1. Sync player to Firestore
  final player = await GamePlayerService.instance.syncLocalPlayerToFirestore();
  
  // 2. Join Playflow lobby
  final lobby = await PlayflowClient.instance.joinGameRoom(code: code);
  
  // 3. Add player to Firestore session
  final participation = PlayerParticipationModel(
    playerId: player!.playerId,
    playerName: player.username,
    playerAvatar: player.profileImage, // optional image
    joinedAt: DateTime.now(),
    status: PlayerStatus.active,
    // ... other fields
  );
  
  await FirebaseFirestoreService.instance.addPlayer(
    lobby.id!,
    participation,
  );
}
```

## API Reference

### GamePlayerService Methods

| Method | Description |
|--------|-------------|
| `getCurrentPlayerInfo()` | Get username, playerId, and image from local storage |
| `savePlayerInfo()` | Save player to local storage and Firestore |
| `updateProfileImage()` | Update profile image |
| `getPlayer()` | Get player from Firestore by playerId |
| `syncLocalPlayerToFirestore()` | Sync local player to Firestore |
| `updateLastActive()` | Update last active timestamp |
| `clearPlayerData()` | Clear all player data (logout) |
| `getCurrentUsername()` | Get current username |
| `getCurrentProfileImage()` | Get current profile image |

### FirebaseFirestoreService Player Methods

| Method | Description |
|--------|-------------|
| `saveGamePlayer()` | Save/update game player in Firestore |
| `getGamePlayer()` | Get game player by playerId |
| `updateGamePlayerLastActive()` | Update last active timestamp |
| `updateGamePlayerImage()` | Update profile image |
| `gamePlayerExists()` | Check if player exists |
| `getOrCreateGamePlayer()` | Get existing or create new player |

### AppService Player Methods (Updated)

| Method | Description |
|--------|-------------|
| `setPlayerId()` | Save username (playerId) to local storage |
| `getPlayerId()` | Get playerId from local storage |
| `getPlayerName()` | Get player name (same as playerId) |
| `setProfileImage()` | Save profile image path |
| `getProfileImage()` | Get profile image path |
| `getProfileImageSync()` | Get profile image synchronously |
| `clearProfileImage()` | Clear profile image |
| `clearPlayerId()` | Clear playerId |

## Key Concepts

1. **Username = Player ID**: Always the same value
2. **Profile Image is Optional**: Can be null/empty
3. **Two Storage Layers**: Local (fast) + Firestore (sync)
4. **Two Models**: UserModel (Mash platform) vs GamePlayerModel (game)
5. **Sync on Game Start**: Call `syncLocalPlayerToFirestore()` when starting a game

## Best Practices

1. **Save player info** when user enters username
2. **Sync to Firestore** when creating/joining a lobby
3. **Update last active** periodically during gameplay
4. **Clear data** on logout
5. **Handle null images** gracefully (they're optional)

## Testing

```dart
// Test player creation
final player = await GamePlayerService.instance.savePlayerInfo(
  username: 'test_player',
  profileImage: '/test/image.jpg',
);
assert(player.playerId == 'test_player');
assert(player.username == 'test_player');

// Test retrieval
final retrieved = await GamePlayerService.instance.getPlayer('test_player');
assert(retrieved != null);
assert(retrieved.profileImage == '/test/image.jpg');

// Test sync
await GamePlayerService.instance.syncLocalPlayerToFirestore();
```

## Status

✅ **COMPLETE** - All player management features implemented
✅ **UserModel (Freezed) UNTOUCHED** - No corruption or damage
✅ **Clean Integration** - Works with existing code
✅ **Optional Images** - Profile images are optional

Ready to use!

