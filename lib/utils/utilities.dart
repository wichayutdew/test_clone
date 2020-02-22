class Utils {
  static String getUsername(String email){
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name){
    List<String> namesplit = name.split(" ");
    String firstNameInitials = namesplit[0][0];
    String lastNameInitials = namesplit[1][0];
    return firstNameInitials + lastNameInitials;
  }
  
}