# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://github.com/robmorgan/infraspec"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "9cdb7681effd7931c373dd63d7ed2214ce8315d242db17987c77ed4cae8f34ae"
  # license "Fair" # license question, https://github.com/robmorgan/infraspec/issues/4
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a16815dd32f25e2ad4f07ff5c95639590d7a0594b925ceca9bc2ec9ed29bd4c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f1e6ccea87cdc4c0b7435424fc0e1eea257582c3541e9e0d03a58933ee46af3"
    sha256 cellar: :any_skip_relocation, ventura:       "fe41b81fd8c1f49a7244c8224a1ec08e405c47a1f8e91314f5fcdefb2bb02254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de9b3af876dc9f3961ec53a6b0638a63b69e6b38ce1cd1bdfb91b9a616e2ae7a"
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
