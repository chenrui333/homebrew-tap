class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "1c80b7c35bb5de4e9493cffa34cf732548715a11bb2fba840020b69f273e43a2"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f45e7081a83fc46446c4e900694f3e5d8bef364fa86c4e9554e61ba32bd2eac1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70267b3710cf1993694bc6e5431b030ef2429ceea24e7138d3a3c3a407718c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38faef55d67c45871e674feee4c4b7eb4354e05ca66513d3984436a810d51608"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df2f942f3d08fd90311348ced7d2239afa1e4469160313af5dbf27f719248a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6887145dff89d57605f4de94e0d4ee734be0dd9b35dcf80025c3727382fb0457"
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
