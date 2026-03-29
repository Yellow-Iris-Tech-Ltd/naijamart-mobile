

class NaijaMartEndpoints {
   NaijaMartEndpoints._();

static const String domainUrl = "https://naijamart.com";
static const String baseUrl = "$domainUrl/api/v1/";

 static const String transactionHistoryUrl = "${baseUrl}transaction-history";
//   Live Support URLs
  static const String liveUrl = "https://naijamart.com";

  // Notification URLs
  static const String triggerNotificationUrl = "${baseUrl}post-in-app-notification";
}