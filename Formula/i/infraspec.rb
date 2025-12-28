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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4d3ec36c7a527656ecb052c42b08d7a03c8963a8f0af1b9f6984da347fe5548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d3ec36c7a527656ecb052c42b08d7a03c8963a8f0af1b9f6984da347fe5548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4d3ec36c7a527656ecb052c42b08d7a03c8963a8f0af1b9f6984da347fe5548"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9336ff1fa007daffde37aeb96a0429f5c987aadb475366e63ee7e24978a52f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad3875e90280b41ba176e4d308cf7fa35c02ff723f040d8b27649013ec5d65e"
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
