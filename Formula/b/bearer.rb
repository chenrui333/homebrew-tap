class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "c6cf4b0c46253fb63320cab158761b7bb343df757e73020f89b960eab81e63fd"
  license "Elastic-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fbde6603cfcdec72c6f8987d76e77858aa600cac2e46572061aef58bf05d8db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa8794a1eeb30dac6b3b703278b6282e3d64ad5b01e79e14b25147616dd4149"
    sha256 cellar: :any,                 arm64_linux:   "05f8d5e3824081a6f753e82713db650dd1308c4232bb119d0f49b996016a2ebb"
    sha256 cellar: :any,                 x86_64_linux:  "29e3ea79cf519b61135c68a1ed0e119f0c85a081fef8829cacc90fde8f7b700f"
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
