class HeliusPersonalFinanceTracker < Formula
  desc "Local-first personal finance tracker with CLI and TUI"
  homepage "https://github.com/STVR393/helius-personal-finance-tracker"
  url "https://github.com/STVR393/helius-personal-finance-tracker/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "cb1747212d6e1b22f957f678f594ba242997cbc0d409bd0409bb99f8859ab5c5"
  license "AGPL-3.0-only"
  head "https://github.com/STVR393/helius-personal-finance-tracker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c62ebe7b95078099ac65eaeee4ca495aac2310a620820fa86d76bf84d264a08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4ea029cb4369e94774591a12edd9d273d8aeb4162e33fdc0bdde09ce16f948"
    sha256 cellar: :any,                 arm64_linux:   "e558c814ab083d32bd36dabb08c2afd903323c5f57be74b7223b78229e25d375"
    sha256 cellar: :any,                 x86_64_linux:  "ad858d20194521962878c304a7c88923212a94cce390704c4ab2c94eee1e7e4f"
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
