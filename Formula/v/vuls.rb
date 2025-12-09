class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "ed863bca392c73a13f4a73c296756dbff6c91aff1fb74258bdbb8d1eee2e5afa"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8f4900da910a97661a6719463485968c073ac50fe5805724516edb167d14712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de0bd66b17ab1de48377936dac1f78be22783af9f9aa9854774aad2917128c16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10d8ebd026ae51c22c3a9958c25b32ddffaad696773570a458b7292591dae960"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c06a8947bd8918fd8cfb3c7d9e43970d410ddea94f5507a1fb18e138d0fcc38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b54dfaa72c7ff4e7331d3a4642a03a9e3fdf61e1091556c5891d03502e08d6e"
  end

  depends_on "go" => :build

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/future-architect/vuls/config.Version=#{version}
      -X github.com/future-architect/vuls/config.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"vuls"), "./cmd/vuls"
    system "go", "build", *std_go_args(ldflags:, output: bin/"vuls-scanner"), "./cmd/scanner"
    system "go", "build", *std_go_args(ldflags:, output: bin/"trivy-to-vuls"), "./contrib/trivy/cmd"
    system "go", "build", *std_go_args(ldflags:, output: bin/"future-vuls"), "./contrib/future-vuls/cmd"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snmp2cpe"), "./contrib/snmp2cpe/cmd"
  end

  test do
    # https://vuls.io/docs/en/config.toml.html
    (testpath/"config.toml").write <<~TOML
      [default]
      logLevel = "info"

      [servers]
      [servers.127-0-0-1]
      host = "127.0.0.1"
    TOML

    %w[vuls vuls-scanner].each do |cmd|
      assert_match "Failed to configtest", shell_output("#{bin}/#{cmd} configtest 2>&1", 1)
    end

    %w[trivy-to-vuls future-vuls snmp2cpe].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} version")
    end
  end
end
