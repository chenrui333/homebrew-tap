class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.38.5.tar.gz"
  sha256 "14ffabaff438ba48534af769c3c2e827278a95ca66d30a24c1701132712c73ce"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aee8fcdd34691fac843c5d7e303d6706e56e4ea4a274ca680dbead9f8c3566ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bea5ef8ece0579b2cb88a098e5a93dfd74e10e0c21974957eade67bff973956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c58d9bc6214e3bd3d07a9f99b2d274d28d10e6b59c073b9104f792417596704c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cba84131ed058cfca7efd73f0806a7b64e7feb4a223dfa09370c7512e616ba7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a4caa2596f9099c515c340dc1150756203fcd7fa44bc014e34efc2e19fd774"
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
