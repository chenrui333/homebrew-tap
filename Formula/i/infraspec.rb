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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52893ac154f7bd612b481150ac7d72161dd240b68f7a938b5f94b92ebea66749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e3cc1e02cad52b92476c6df29cc2ef36739602076cd97d0b3f141e302c2d289"
    sha256 cellar: :any_skip_relocation, ventura:       "1ad43ef5716286b337a84cfb423b8b2a43e548dd5e3db60f799ee5fc4acd9816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db94ac5b37d3a1a518ae0c43243220738043085c12c1d768177b09bbc42510e1"
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
