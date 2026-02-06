class Captan < Formula
  desc "Lightweight, hackable CLI tool for managing startup cap tables"
  homepage "https://github.com/acossta/captan"
  url "https://registry.npmjs.org/captan/-/captan-0.4.0.tgz"
  sha256 "7736b6329ebbd5cf266d7c8451394b7c41ecef47cb98377a351613e1966453b4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "079c192625795f97066d28ce8264437d1cc8de0b9a07f04bcf43a7c3a9f5130e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4086dbeb34ac94397bc54dfa31f1e0b2446bc10edaa27ce7ec34c668883f31b8"
    sha256 cellar: :any_skip_relocation, ventura:       "246acfa5c8284f8063801cb1a3a0a2141fb38998778b4937a67692735fed1e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c73aa450bd544319a9151211f39e79bc6144d445ede2dd436d4d25d790a5f72"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/captan --version")

    # 1) Initialize a new cap table non-interactively (no network, fast)
    system bin/"captan", "init",
          "--name", "TestCo",
          "--date", "2024-01-15",
          "--authorized", "1000000",
          "--founder", "Alice Founder:alice@example.com:600000",
          "--founder", "Bob Eng:bob@example.com:400000",
          "--pool-pct", "20"

    # Files should be created
    assert_path_exists testpath/"captable.json", "captable.json was not created" # spellchecker:disable-line

    # 2) Validate (basic)
    output = shell_output("#{bin}/captan validate")
    assert_match "✅ Validation passed. 2 stakeholders, 2 securities, 2 issuances", output

    # 3) Generate ownership report (text)
    report = shell_output("#{bin}/captan report ownership")
    assert_match "📊 Ownership Table", report

    # 4) Export CSV to a file and verify it exists & is non-empty
    csv_path = testpath/"captable.csv" # spellchecker:disable-line
    system bin/"captan", "export", "csv", "--output", csv_path
    assert_path_exists csv_path
  end
end
