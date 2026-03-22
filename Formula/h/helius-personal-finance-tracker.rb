class HeliusPersonalFinanceTracker < Formula
  desc "Local-first personal finance tracker with CLI and TUI"
  homepage "https://github.com/STVR393/helius-personal-finance-tracker"
  url "https://github.com/STVR393/helius-personal-finance-tracker/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "297ab38931dd141639f7576c6c2213717734fad617e2654e0a93f9dae08f27b0"
  license "AGPL-3.0-only"
  head "https://github.com/STVR393/helius-personal-finance-tracker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32cd0b28da1aacce0631b395b6fd1fca0f28106697c82a2c59366f5844b81d7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01afb49245d1b14dfc06050c377c8427e6cb358591a05023913ff30b150fdc76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0491a1b89931ef875e9190128435ebd84785aa08e3b6e63a5f62f5500a7e7a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b3f9b87775ec5a67a9f0b47d23d501eb564a273d8e437e61ce531e586305922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a32be2f7166d1357ac60bf5de07b5bc0284e0114c41e984c7374feec57f131e"
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
