# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://infraspec.sh/"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "268b0b2248303fdaa15357507bacec00c24c8963eef23df85a2a2783414f8ec0"
  license "Apache-2.0"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af6a4d0d8e958cd047ab3e5292ffe44e2b3b6a6862cf40e94eb13cd048b2faec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6a4d0d8e958cd047ab3e5292ffe44e2b3b6a6862cf40e94eb13cd048b2faec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af6a4d0d8e958cd047ab3e5292ffe44e2b3b6a6862cf40e94eb13cd048b2faec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e61fac880f932fa5deb55073ec93c36b6633726dda9b12bf3f0aae3604d6e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dbc9590e2cabcc3ad35c90747f5852d4592c21d04be94f8f1a53d4542baae8a"
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
