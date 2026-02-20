class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "3eb670b85031f72dd0b18657d2a2a935617a74c9deac24876abc0b950cb64b84"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dac38498535420319130daa1ad7d9e2b96dc6c90442a73b1608dddfa5898f6cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33feecb5437cd6509de01d4b1f552a30c007da26079e0f2f8a259c1f9002bc48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ce16d8d64a44eb0f130c473ca09a1c08229b79b1e83d25aabffc6121ed61566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3677d4bad4171db104423cf134fc3cfa4b87b31b071698aa46cfca87dbbc46bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd0d4013798e678d16db23167dd6f82ce8bda114e1e336bc72f065b7d830873f"
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
