class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "c6cf4b0c46253fb63320cab158761b7bb343df757e73020f89b960eab81e63fd"
  license "Elastic-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4dbd5044022f1d68183f9a84cc40fc9986ad40e13a45761c00a9676fc5d0a9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21509e3dba1d1c236cb68179f21c56e7a39a903ef7a57c851f21785d7fde4f5f"
    sha256 cellar: :any,                 arm64_linux:   "00c18ce3fa45234579e40737db6867c3914796b9d48d4b0926effecb6ed0bf2c"
    sha256 cellar: :any,                 x86_64_linux:  "d1a738c1776d8985619d92c10d6fb8ebb9bb5e8e63713cd0713e210776700943"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/bearer/bearer/cmd/bearer/build.Version=#{version}
      -X github.com/bearer/bearer/cmd/bearer/build.CommitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bearer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bearer version 2>&1")

    # Use a local rule so the scan test does not fetch default rules or version metadata.
    rules_dir = testpath/"rules"
    rules_dir.mkpath
    (rules_dir/"test.yml").write <<~YAML
      patterns:
        - |
          console.log($<...>)
      languages:
        - javascript
      severity: low
      metadata:
        description: Detect a test console log.
        id: javascript_test_console_log
    YAML
    (testpath/"test.js").write 'console.log("local test");'
    command = [
      "#{bin}/bearer scan #{testpath}/test.js",
      "--disable-version-check",
      "--disable-default-rules",
      "--exit-code=0",
      "--format=jsonv2",
      "--external-rule-dir=#{rules_dir}",
    ].join(" ")
    output = shell_output(command)
    assert_match "javascript_test_console_log", output
  end
end
