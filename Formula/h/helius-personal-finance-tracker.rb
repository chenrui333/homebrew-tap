class HeliusPersonalFinanceTracker < Formula
  desc "Local-first personal finance tracker with CLI and TUI"
  homepage "https://github.com/STVR393/helius-personal-finance-tracker"
  url "https://github.com/STVR393/helius-personal-finance-tracker/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "f8cb082d58ceec4002d5b7eb6180fdebfbb721eded4cd15b61556cde50ebd91d"
  license "AGPL-3.0-only"
  head "https://github.com/STVR393/helius-personal-finance-tracker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2e84a3cbae0777390e193080aa561b768056dc5295f429b9a449179eea9df2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6f51374a1e91a47133b854c2e59743485bc821d57d10545bec054503d71bdaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fed6e0eadb0d1eb3fcf8b721a5284ea4c414ae93e32126f276c6fe4e65afa8fd"
    sha256 cellar: :any,                 arm64_linux:   "79547eeb3ae35d2e1624cf77b74725edb578e57329346538cfa2ebe44a7313ae"
    sha256 cellar: :any,                 x86_64_linux:  "d295eaf3b0659c549842011cfc0f31cddab888dd669885b914177d6467ad3331"
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
