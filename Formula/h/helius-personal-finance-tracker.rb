class HeliusPersonalFinanceTracker < Formula
  desc "Local-first personal finance tracker with CLI and TUI"
  homepage "https://github.com/STVR393/helius-personal-finance-tracker"
  url "https://github.com/STVR393/helius-personal-finance-tracker/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "cb1747212d6e1b22f957f678f594ba242997cbc0d409bd0409bb99f8859ab5c5"
  license "AGPL-3.0-only"
  head "https://github.com/STVR393/helius-personal-finance-tracker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30fd54c4b49f5248def08294ec5b20d3f624ec52f35f4228749e765499d13315"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75f84df454690e4cf7807a11e544e990192aebb98df566874d69d160f825d4e6"
    sha256 cellar: :any,                 arm64_linux:   "f82ecda1fd2c678b21381a5336ff90168948d367072fd2857b9af2d1460c451c"
    sha256 cellar: :any,                 x86_64_linux:  "5f76b8a12fdd250c05f9be3159426cca805c29fe48c6a812e7b1ce313bf5a4e3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helius --version")

    db = testpath/"tracker.db"
    init_output = shell_output("#{bin}/helius --db #{db} init --currency USD")
    assert_match "Initialized database", init_output

    system bin/"helius", "--db", db, "account", "add", "Checking",
           "--type", "checking", "--opening-balance", "1000.00", "--opened-on", "2026-01-01"
    system bin/"helius", "--db", db, "category", "add", "Groceries", "--kind", "expense"
    system bin/"helius", "--db", db, "tx", "add",
           "--type", "expense", "--amount", "25.50", "--date", "2026-03-02",
           "--account", "Checking", "--category", "Groceries", "--payee", "Market"

    balance_output = shell_output("#{bin}/helius --db #{db} balance --json")
    assert_match "\"account_name\": \"Checking\"", balance_output
    assert_match "\"current_balance_cents\": 97450", balance_output
  end
end
