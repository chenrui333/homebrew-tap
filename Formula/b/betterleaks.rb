class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "8f7d45ed52c58b793aaec84cdb04474c2e99d57b04de6cc40dd16f90a68de305"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "244b438c7f23008b54c0e7aeeabe7db39a69f6e5a254bc40260ffaaeacd08627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "244b438c7f23008b54c0e7aeeabe7db39a69f6e5a254bc40260ffaaeacd08627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "244b438c7f23008b54c0e7aeeabe7db39a69f6e5a254bc40260ffaaeacd08627"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8685db945294b2cfc1ec08952d1ebbdce2386fc247df22370c9f3db2de3c6901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52bc272be61a4d21fe631a523c8efbc115b5e216f1a5b6e864a13e912241f1b2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/betterleaks/betterleaks/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"betterleaks", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/betterleaks --version")

    (testpath/"betterleaks.toml").write <<~TOML
      title = "test-config"

      [[rules]]
      id = "custom-secret"
      regex = '''SECRET_[A-Z0-9]{8}'''
    TOML

    (testpath/"secrets.txt").write "prefix SECRET_ABC12345 suffix\n"

    report = testpath/"report.json"
    shell_output(
      "#{bin}/betterleaks dir --no-banner --log-level error " \
      "--config #{testpath}/betterleaks.toml " \
      "--report-format json --report-path #{report} #{testpath}/secrets.txt 2>&1",
      1,
    )

    findings = JSON.parse(report.read)
    assert_equal 1, findings.length
    assert_equal "custom-secret", findings.first["RuleID"]
  end
end
