# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://infraspec.sh/"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "27058b9c2c1267625a21eece2e2cb81b9562b38e748914967cdfb2daf67d77cf"
  license "Apache-2.0"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f335b582e4ef62d869e6e54f3015e6a618f63ec14504834186fc6f51064e4ff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f335b582e4ef62d869e6e54f3015e6a618f63ec14504834186fc6f51064e4ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f335b582e4ef62d869e6e54f3015e6a618f63ec14504834186fc6f51064e4ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b35d958e6861ace980be5ff6d3de3872a0bb2fd27b1797a51b6ee23bc2d5ab6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97cc328b2cf9ba604e31cf3690bb002c38df11e04950bdd311c95285a3f10ea5"
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
