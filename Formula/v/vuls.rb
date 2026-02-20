class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "23ad508d52db993eb9477f186e9e2e0457b3531c32a05de5b78afa5eab233edb"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be51d171d0e87a01d8a528abc54b7cb6dd524b2577dcc0d0911c15b50daf3fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3191d4d41a3e4b61bf4bb4fa88edffb854c3b1e736f1d0ac5d81b67351940f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60804f91a5c6352f1119b352fc68c93648f65a36f16a2f873c113be67ad65fcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4454f06e9484d7678cf75ae5bb20ca3f0235b0e864fc67615e0014fdecae84b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e6188bf266e5cc0aa3b02e04d30854f920323a7782eeeb9943d33ed6d487d52"
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
