class SqlFormatter < Formula
  desc "Whitespace formatter for different query languages"
  homepage "https://sql-formatter-org.github.io/sql-formatter/"
  url "https://registry.npmjs.org/sql-formatter/-/sql-formatter-15.4.10.tgz"
  sha256 "7197a33453d262f0a62fe28c52d9ea7e6793f68a4a9e352b5e3b622da2283ee9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ba00c5eec881a702445900a1367ce148f6a48dabc29796f3a8cc0bfa8ac6f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14bc9506d99faf5a4049fb21105f365e2de68fa7030ebbf1b376f3e206c10a68"
    sha256 cellar: :any_skip_relocation, ventura:       "f92e6020850ae94fc1477f7cf22fd6040edd044a620346abbaa3415fb4d12748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "707e8c9aa8faa4b7dee410e06d464c814bc9f20ae859b5c53a9f67821009aaee"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/sql-formatter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sql-formatter --version")

    (testpath/"test.sql").write <<~SQL
      SELECT * FROM users WHERE id = 1;
    SQL

    system bin/"sql-formatter", "--fix", "test.sql"
    expected_output = <<~SQL
      SELECT
        *
      FROM
        users
      WHERE
        id = 1;
    SQL

    assert_equal expected_output, (testpath/"test.sql").read
  end
end
