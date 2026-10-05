class SslChecker < Formula
  desc "Fast and beautiful program to check all your https endpoints"
  homepage "https://github.com/fabio42/ssl-checker"
  url "https://github.com/fabio42/ssl-checker/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "a29d9ff77be95acbc4e1100b6e0dce867f5554d9bd3f0ae7bbc4a8c825f07ec8"
  license "MIT"
  head "https://github.com/fabio42/ssl-checker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5332cbf012db83f7bc932627c86eb2e0930ed0bcb15647361b53699051015568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5332cbf012db83f7bc932627c86eb2e0930ed0bcb15647361b53699051015568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5332cbf012db83f7bc932627c86eb2e0930ed0bcb15647361b53699051015568"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af12e04868f1d1d7b57db943e0d4b2a96bf7720cb2fa570280406b3e112be188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8b8a3e75620b1b53f553e4b76eecc85bfec2c4051f983a5147b08b1c97ee029"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/fabio42/ssl-checker/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ssl-checker", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssl-checker --version")

    # Certificate checks need remote TLS endpoints; configuration handling is local
    (testpath/"config.yaml").write <<~YAML
      queries:
        qa:
          - example.com
        prod: "#{testpath}/domains.txt"
    YAML
    output = shell_output("#{bin}/ssl-checker environments --config #{testpath}/config.yaml")
    assert_match "Available environments:", output
    assert_match "qa", output
    assert_match "prod", output

    (testpath/"bad.yaml").write <<~YAML
      queries:
        qa: 42
    YAML
    output = shell_output("#{bin}/ssl-checker --config #{testpath}/bad.yaml 2>&1", 1)
    assert_match "Unsupported data type in queries option", output
  end
end
