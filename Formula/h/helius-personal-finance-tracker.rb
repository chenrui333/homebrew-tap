class HeliusPersonalFinanceTracker < Formula
  desc "Local-first personal finance tracker with CLI and TUI"
  homepage "https://github.com/STVR393/helius-personal-finance-tracker"
  url "https://github.com/STVR393/helius-personal-finance-tracker/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "a5b2bb8490894ba1acdc71bf440b54e5206d65a4bef0a2754965754b47bf819a"
  license "AGPL-3.0-only"
  head "https://github.com/STVR393/helius-personal-finance-tracker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9248b22683c3898774ead1181962ab05f9ecd3e9d28cec3e6f83b7631473e60c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c278d8c6afaeb720b069bc0ea4e6bd9dffef44d23326a360dbf05b961a12d890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d84ddc4dc3e2d7e9f21eff052c4acf875073bf51c62b0e32c6c9fee690409406"
    sha256 cellar: :any,                 arm64_linux:   "6f2df6ec2e8616efc5a027a5824338197722ccf97b55492a0feeba509a53f48e"
    sha256 cellar: :any,                 x86_64_linux:  "acf58a93d9ea46f72853678018c10f2b5637aa58c8db8c0196af6554d2722238"
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
