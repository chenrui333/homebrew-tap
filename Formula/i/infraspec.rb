# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://infraspec.sh/"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "7f8327fe065861b5158590b40d86ce508429ff95d729c08faaaaf5768acb3e23"
  license "Apache-2.0"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bbc34191676ef4990ff254dabd9984373761293a8559fd3358829f94cdfe00c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bbc34191676ef4990ff254dabd9984373761293a8559fd3358829f94cdfe00c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bbc34191676ef4990ff254dabd9984373761293a8559fd3358829f94cdfe00c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "403394b32ff0ad2f39333d640307d47e67ca12585e1bf6ff1306889834b8c0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49027ed6ceaa4d714ac63d201d429ba295de885720fa4b5eac4b2f20f6f87d96"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/robmorgan/infraspec/internal/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/infraspec"

    generate_completions_from_executable(bin/"infraspec", shell_parameter_format: :cobra)
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
