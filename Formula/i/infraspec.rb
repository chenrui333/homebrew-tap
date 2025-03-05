# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://github.com/robmorgan/infraspec"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "e7ddad0d555edf0cb5df28c2e7c8c9ec7336765feaa3b0304386e2ee01427293"
  # license "Fair"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "693764d4253b3565209cd3414e3f08dc5f730f17caa606dca4ba5f347e974b7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71ffe6ed7adb6b98ea24ffc95987f1ce1052a12a341e01e0f40c376a2c4abad2"
    sha256 cellar: :any_skip_relocation, ventura:       "fb40158b10fed5b69994a496d82affc09dada0e6d3b0b17760af11a411a3fcd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4911b4a13f48c968719ece0e0f7f21ede6f6a421f070ce664d47a5d87f3d4129"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
    output = shell_output("#{bin}/infraspec test.feature")
    assert_match "Test execution completed", output
  end
end
