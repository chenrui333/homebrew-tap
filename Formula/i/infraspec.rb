# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://infraspec.sh/"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "95347ac1fb40774f9dd2f225b5ed61d0f30f781a798ffc4da594eaa577a01dd9"
  license "Apache-2.0"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b24047e7526d99cbcef0477b966e5d51ef0b34691e135772f27e93c99bc6755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b24047e7526d99cbcef0477b966e5d51ef0b34691e135772f27e93c99bc6755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b24047e7526d99cbcef0477b966e5d51ef0b34691e135772f27e93c99bc6755"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f32deb95a3edd85eebe13b42980879ef019b9299bc0a65ea8b6866257a3979c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bdefc0ae5e7dbd2a8502b9c040d799ba4d05f6e342d00da0bc87aec404441d8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/robmorgan/infraspec/internal/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/infraspec"

    generate_completions_from_executable(bin/"infraspec", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infraspec --version")

    (testpath/"test.feature").write <<~EOS
      Feature: Test infrastructure
        Scenario: Check if the infrastructure is up
          Given I have a running server
          When I check the server status
          Then the server should be running
    EOS
    output = shell_output("#{bin}/infraspec test.feature").gsub(/\e\[[;\d]*m/, "")
    assert_match "Test your AWS infrastructure in plain English, no code required", output
  end
end
