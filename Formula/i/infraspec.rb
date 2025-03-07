# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://github.com/robmorgan/infraspec"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "4218acf668c060633184d4b7519be7bc49ee233ef5abd4378f2eb4cf223e1ff5"
  # license "Fair" # license question, https://github.com/robmorgan/infraspec/issues/4
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "770197b648f1615c147a5af7d87887c7b2135adf611e5520929bf80b8724a31d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e485d234afd9c55dbd340e2c761b0d572fb825aed7318d339811cf7dc4d0e65d"
    sha256 cellar: :any_skip_relocation, ventura:       "c3b04373dce420aa21b7845a2e22dad13d6bd5f4d26cd8938354e56584bf7004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fadf1450f59880cea3dbe0a8bc95beac837dfa29c8de816b0975260850d19ed6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    system bin/"infraspec", "--help"

    (testpath/"test.feature").write <<~EOS
      Feature: Test infrastructure
        Scenario: Check if the infrastructure is up
          Given I have a running server
          When I check the server status
          Then the server should be running
    EOS
    output = shell_output("#{bin}/infraspec test.feature").gsub(/\e\[[;\d]*m/, "")
    assert_match "You can implement step definitions for undefined steps with these snippets", output
  end
end
