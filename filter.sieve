require ["fileinto", "include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*",
spamtest :value "ge" :comparator "i;ascii-numeric" "${1}")
{
    return;
}

# ===== 2) Gmail-like categories =====
# Social: networks/messaging platforms
if anyof (
  address :domain :is "From" "facebookmail.com",
  address :domain :is "From" "twitter.com",
  address :domain :is "From" "x.com",
  address :domain :is "From" "linkedin.com",
  address :domain :is "From" "instagram.com",
  address :domain :is "From" "pinterest.com",
  address :domain :is "From" "tiktok.com",
  address :domain :is "From" "slack.com",
  address :domain :is "From" "discord.com",
  address :domain :is "From" "discordapp.com",
  address :domain :is "From" "telegram.org",
  address :domain :is "From" "whatsapp.com",
  address :domain :is "From" "signal.org",
  address :domain :is "From" "snapchat.com",
  address :domain :is "From" "reddit.com",
  address :domain :is "From" "redditmail.com",
  address :domain :is "From" "twitch.tv",
  address :domain :is "From" "youtube.com"
) {
  fileinto "Social";
  stop;
}

# Updates: receipts, account notifications, dev tools, financial services
if anyof (
  address :domain :is "From" "github.com",
  address :domain :is "From" "notify.github.com",
  address :localpart :is "From" "notify",
  address :localpart :matches "From" "*no-reply*",
  address :localpart :matches "From" "*noreply*",
  address :contains "From" "atlassian.net",
  address :domain :is "From" "jira.com",
  
  # E-commerce & shopping
  address :domain :is "From" "amazon.com",
  address :domain :is "From" "amazon.co.jp",
  address :domain :is "From" "ebay.com",
  address :domain :is "From" "etsy.com",
  address :domain :is "From" "walmart.com",
  address :domain :is "From" "target.com",
  address :domain :is "From" "bestbuy.com",
  
  # Payment services
  address :domain :is "From" "paypal.com",
  address :domain :is "From" "stripe.com",
  address :domain :is "From" "square.com",
  address :domain :is "From" "venmo.com",
  
  # Tech companies
  address :domain :is "From" "apple.com",
  address :domain :is "From" "microsoft.com",
  address :domain :is "From" "google.com",
  address :domain :is "From" "adobe.com",
  address :domain :is "From" "dropbox.com",
  address :domain :is "From" "spotify.com",
  address :domain :is "From" "netflix.com",
  
  # Financial institutions (receipts/notifications)
  address :domain :is "From" "bankofamerica.com",
  address :domain :is "From" "chase.com",
  address :domain :is "From" "wellsfargo.com",
  address :domain :is "From" "citi.com",
  address :domain :is "From" "capitalone.com",
  address :domain :is "From" "americanexpress.com",
  address :domain :is "From" "fidelity.com",
  address :domain :is "From" "vanguard.com",
  
  # Chinese services
  address :contains "From" "招商银行",
  address :contains "From" "携程",
  address :contains "From" "支付宝",
  address :contains "From" "淘宝",
  address :contains "From" "京东"
) {
  fileinto "Updates";
  stop;
}

# Forums: list traffic, communities, and discussion platforms
# Prefer List-Id header for reliability; also include common forum senders
if anyof (
  exists "List-Id",
  header :contains "List-Id" ["discourse", "groups.google.com", "groups.io", "mailman", "phpbb", "vbulletin"],
  header :contains "List-Unsubscribe" "<mailto:",
  address :domain :is "From" "googlegroups.com",
  address :domain :is "From" "groups.google.com",
  address :domain :is "From" "groups.io",
  address :domain :is "From" "discourse.org",
  address :domain :is "From" "stackoverflow.com",
  address :domain :is "From" "stackexchange.com",
  address :domain :is "From" "github.com",  # for GitHub notifications
  address :domain :is "From" "community.",
  address :domain :is "From" "forum.",
  address :domain :is "From" "discuss.",
  address :domain :is "From" "lists.",
  address :domain :is "From" "mailinglist.",
  header :contains "Precedence" "list",
  header :contains "X-Mailer" ["phpBB", "vBulletin", "Discourse"]
) {
  fileinto "Forums";
  stop;
}

# Promotions: typical marketing platforms and bulk markers
if anyof (
  header :contains "Precedence" ["bulk", "list", "junk"],
  header :contains "List-Id" ["mailchimp", "sendgrid", "sparkpost", "hubspot", "marketo", "salesforce"],
  address :domain :is "From" "mailchimp.com",
  address :domain :is "From" "sendgrid.net",
  address :contains "From" "mail-magazine",
  address :contains "From" "okusurinavi.shop",
  address :contains "From" "Lovable",
  address :domain :is "From" "sparkpostmail.com",
  address :domain :is "From" "hubspot.com",
  address :domain :is "From" "marketo.com"
) {
  fileinto "Trash";
  stop;
}

# ===== 3) Default: Inbox =====
# All other emails go to Inbox by default
