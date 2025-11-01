class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "38daea316bc6967cbabd6a8571718b3958e84c464a57895562992297468e0a92"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

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
