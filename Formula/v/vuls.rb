class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.38.4.tar.gz"
  sha256 "189e3351d0af0fea685e9c4b1db7c5fa255ec96f49ee13eadddad822603e1905"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37c7bde324e2df9fa909edd9636309a365cdd9cc4cb80a19b82994ec7b392c81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b79a390a8fa00a191f932d7ab94b28683ad51bbb9856fb52fff11b6bbd80991b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "975826592d0f488245106dfd9b812cda60723cf4de322cb6354056c17f0f92dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fced21b66ea31c4ee0785f3eee4e53a531de9e56aeeb27a545f67839792bee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64d70ac9baa23c96c6220d55fec4216b1117b13c81245a6418fc5c8bca1380cf"
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
