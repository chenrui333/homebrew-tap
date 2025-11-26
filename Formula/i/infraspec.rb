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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3593fb49a3cc867a590bb571980464d9542bcc063c0990bc33a5399affe49f26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3593fb49a3cc867a590bb571980464d9542bcc063c0990bc33a5399affe49f26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3593fb49a3cc867a590bb571980464d9542bcc063c0990bc33a5399affe49f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13de18b210035bc560c33c7fec7f25dc0281b947645c2a22e046060d11fdd982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b63865c74c8fa0b25355ac83b2878386863adfc94814f6f371a57974c3b2c35"
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
