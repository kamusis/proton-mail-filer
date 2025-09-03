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
  address :domain :is "From" "slack.com"
) {
  fileinto "Social";
  stop;
}

# Updates: receipts, account notifications, dev tools
if anyof (
  address :domain :is "From" "github.com",
  address :domain :is "From" "notify.github.com",
  address :localpart :is "From" "notify",
  address :localpart :matches "From" "*no-reply*",
  address :localpart :matches "From" "*noreply*",
  address :contains "From" "atlassian.net",
  address :domain :is "From" "jira.com",
  address :domain :is "From" "amazon.com",
  address :domain :is "From" "amazon.co.jp",
  address :domain :is "From" "paypal.com",
  address :domain :is "From" "stripe.com",
  address :domain :is "From" "apple.com",
  address :domain :is "From" "netflix.com",
  address :domain :contains "From" "discord",
  address :contains "From" "招商银行",
  address :contains "From" "携程"
) {
  fileinto "Updates";
  stop;
}

# Forums: list traffic and communities
# Prefer List-Id header for reliability; also include common forum senders
if anyof (
  exists "List-Id",
  address :domain :is "From" "googlegroups.com",
  header :contains "List-Id" "discourse",
  address :domain :is "From" "groups.io",
  address :domain :is "From" "reddit.com",
  address :domain :is "From" "redditmail.com"
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
