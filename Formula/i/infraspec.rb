# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://infraspec.sh/"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "f1ed47fcc65d49081b5ecc1b4985de98f91dbdf3ce0b8f9cdb73185f5edf63d0"
  license "Apache-2.0"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "178c429d52c2504efaafd3ca198649394dab39dc0fa348c4278bd4518ea6f676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "178c429d52c2504efaafd3ca198649394dab39dc0fa348c4278bd4518ea6f676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "178c429d52c2504efaafd3ca198649394dab39dc0fa348c4278bd4518ea6f676"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f41245f1aaeb4eee8642f60d1643068500e9ef8208ea0f2be3b49ae9cf822fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c79fb28575b7a10a28d0142daab385de85d03b3d8d5b51a9f56f00b2bcc1dfa"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
    assert_match "You can implement step definitions for undefined steps with these snippets", output
  end
end
