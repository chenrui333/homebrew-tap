# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://github.com/robmorgan/infraspec"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "2d18d072698649918a7120084316d45b27fa0b039bb90be003f892b0a2667e54"
  license "Apache-2.0"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1373dc537a65dea5a0e792a2595b5795e32ed7179f59700fee824d130cc71c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fddd9e0c53de4944f52fa53afdff6348e25dd1d6d4db949dd4a0883b0be20c81"
    sha256 cellar: :any_skip_relocation, ventura:       "078c9d9fe56d32f4c0dbe8a239db5407aecf6e453441504b23b0720e6d9802bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b365da1d9fd0c0c0b6684f2f36e4cb92df56210e649e3121b30dbdb21043be3f"
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
    assert_match "You can implement step definitions for undefined steps with these snippets", output
  end
end
