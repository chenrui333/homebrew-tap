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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "978c915d8b7be64e8a3a795328ba05e46a7b016423427705f0d0ab5288ac4075"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "978c915d8b7be64e8a3a795328ba05e46a7b016423427705f0d0ab5288ac4075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "978c915d8b7be64e8a3a795328ba05e46a7b016423427705f0d0ab5288ac4075"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a52dc5201b80b411a83872a46463acb66656f2f83944da58bae69b33c02fb93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8e4ec05e6fc5f245d3e7fdb2761ac178ef581bd10661957272251667794710a"
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
