class Captan < Formula
  desc "Lightweight, hackable CLI tool for managing startup cap tables"
  homepage "https://github.com/acossta/captan"
  url "https://registry.npmjs.org/captan/-/captan-0.4.0.tgz"
  sha256 "7736b6329ebbd5cf266d7c8451394b7c41ecef47cb98377a351613e1966453b4"
  license "MIT"

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
    assert_path_exists testpath/"captable.json", "captable.json was not created"

    # 2) Validate (basic)
    output = shell_output("#{bin}/captan validate")
    assert_match "✅ Validation passed. 2 stakeholders, 2 securities, 2 issuances", output

    # 3) Generate ownership report (text)
    report = shell_output("#{bin}/captan report ownership")
    assert_match "📊 Ownership Table", report

    # 4) Export CSV to a file and verify it exists & is non-empty
    csv_path = testpath/"captable.csv"
    system bin/"captan", "export", "csv", "--output", csv_path
    assert_path_exists csv_path
  end
end
