class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.38.4.tar.gz"
  sha256 "189e3351d0af0fea685e9c4b1db7c5fa255ec96f49ee13eadddad822603e1905"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf96305a0f846706a4d6768e34189bd0ac2adb94ffb5c54ffe002a8c011aeb8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1606ef8a63e459b70c76649ce557e2987711d9e09fb3e9a075c4ecfa2dc47f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7276a25a55928331fb5bc6237427fbe63218eea85861889f33a5cac55ba49d80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e897a36f364e5469fed94676226c9eabd013903ae3759e0d1bd839954eb40a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "236f2eb480dfd220ddf708c4cf1e232d83acfab07514a536a84249da00625adb"
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
