# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://github.com/robmorgan/infraspec"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "7f8327fe065861b5158590b40d86ce508429ff95d729c08faaaaf5768acb3e23"
  license "Apache-2.0"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e55d971a21ba71f0eb2fad1f0f0254e09387b6fc8e90dc6a40a6cbf6165fd323"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e55d971a21ba71f0eb2fad1f0f0254e09387b6fc8e90dc6a40a6cbf6165fd323"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ce1dde2899d94ca159b3a27444747f3cd0922423efbee82a9608a20d48f5b76"
    sha256 cellar: :any,                 x86_64_linux:  "c840d86399e20329a639a64af4a45e7f1353acf393356fb0ba48c3db19a9652f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
    # The default mode starts a loopback AWS emulator; `--live` skips it and undefined steps make no AWS calls.
    ENV["INFRASPEC_TELEMETRY_DISABLED"] = "1"
    output = shell_output("#{bin}/infraspec --live test.feature").gsub(/\e\[[;\d]*m/, "")
    assert_match "Test your AWS infrastructure in plain English, no code required", output
    assert_match "Undefined: 3", output
  end
end
