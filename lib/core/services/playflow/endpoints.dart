class PlayflowEndpoints {
  static const String baseUrl = 'https://api.scale.computeflow.cloud';

  static const String lobby = '/lobbies';
  static String lobbyHeartbeat(String lobbyId) =>
      'https://api.scale.computeflow.cloud/lobbies-sse/$lobbyId/events';
}
