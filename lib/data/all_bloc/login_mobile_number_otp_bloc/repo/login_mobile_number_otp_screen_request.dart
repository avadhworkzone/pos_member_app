/// username : 0129505989
/// password : 9999
/// grant_type:password
/// scope:member_scope
/// client_id:{{member_client_id}}
/// client_secret:{{member_client_secret}}

class LoginMobileNumberOtpScreenRequest {
  LoginMobileNumberOtpScreenRequest({
    String? userName,
    String? password,
    String? grantType,
    String? scope,
    String? clientId,
    String? clientSecret,
  }) {
    _userName = userName;
    _password = password;
    _grantType = grantType;
    _scope = scope;
    _clientId = clientId;
    _clientSecret = clientSecret;
  }

  LoginMobileNumberOtpScreenRequest.fromJson(dynamic json) {
    _userName = json['username'];
    _password = json['password'];
    _grantType = json['grant_type'];
    _scope = json['scope'];
    _clientId = json['client_id'];
    _clientSecret = json['client_secret'];
  }

  String? _userName;
  String? _password;
  String? _grantType;
  String? _scope;
  String? _clientId;
  String? _clientSecret;

  String? get userName => _userName;

  String? get password => _password;

  String? get grantType => _grantType;

  String? get scope => _scope;

  String? get clientId => _clientId;

  String? get clientSecret => _clientSecret;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _userName;
    map['password'] = _password;
    map['grant_type'] = _grantType;
    map['scope'] = _scope;
    map['client_id'] = _clientId;
    map['client_secret'] = _clientSecret;
    return map;
  }
}
