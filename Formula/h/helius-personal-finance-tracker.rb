class HeliusPersonalFinanceTracker < Formula
  desc "Local-first personal finance tracker with CLI and TUI"
  homepage "https://github.com/STVR393/helius-personal-finance-tracker"
  url "https://github.com/STVR393/helius-personal-finance-tracker/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "b785c7b7afe32e0334c0449dbd19ececd193fceafd3b407e687e6330632dc098"
  license "AGPL-3.0-only"
  head "https://github.com/STVR393/helius-personal-finance-tracker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c217e810bc169e7c5c0b71d88444ddaf1c0ecacb6b5706b048f3e0d830e2b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adb079817661a22fc52abfb3d64997f3bdc9e43c54e0982aa6867774dea25f28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fff137308032de554b1a8d19c028980f7afc39678359db902ebadb6693bac3e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "545a4c1224ac4b07dbbe7efbe251ac2d6324541029358c798f85fedeff156799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0fbb85da9735863b41acd38fc660783ede29fc97896ac254440fb8ab5c7a709"
  end

  depends_on "rust" => :build

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
