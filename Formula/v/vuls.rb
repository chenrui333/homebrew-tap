class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "14dec8c42d23b95b1efe7def041a0a3306e52d863de9d33affaa71002a9ca7ec"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "983698a8258ea5599fbb152f653d9982b8e9ea642b65a728002dcbdc665e1341"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fdd0822f34835aa180661cebeee4fad79b37ae7ba891f7dd0b67c10b75b6301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa05941aa05c957aac67b4b14c6e51e0eddc00b49e7d3ab13985a350d40c922b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a655850afe1706d4ff732e661d1c3154ac5d6ccf29a8e102563dfb696373b218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2052389f16295c6eca389202a5365f30b369186b5f2ee31c566d2d5a9f0977e2"
  end

  depends_on "go" => :build

  def install
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
