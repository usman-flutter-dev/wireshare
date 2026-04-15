//
//
class ServerConfig {
  final int port;
  final String username;
  final String password;
  final bool readOnly;

  const ServerConfig({
    this.port = 2121,
    this.username = 'wireshare',
    this.password = '1234',
    this.readOnly = false,
  });

  ServerConfig copyWith({
    int? port,
    String? username,
    String? password,
    bool? readOnly,
  }) {
    return ServerConfig(
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      readOnly: readOnly ?? this.readOnly,
    );
  }
}
