class Agent {
  String? username;
  String? email;
  String? telephone;
  String? firstname;
  String? lastname;
  String? roles;

  Agent({this.username, this.email, this.telephone, this.firstname, this.lastname, this.roles});

  @override
  String toString() {
    return 'Agent{username: $username, email: $email, telephone: $telephone, firstname: $firstname, lastname: $lastname, roles: $roles}';
  }

  Agent.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    telephone = json['telephone'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    roles = json['roles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['telephone'] = telephone;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['roles'] = roles;
    return data;
  }
}
