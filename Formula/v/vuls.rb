class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "be6fa9401085307153a618caccf0626c226027f86299336b0915ded71a60c119"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fa8927cff840dee891f9b2afdded40190442611e876b28c88dd03a61c21bfec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04a67e5728a58a719801a99e120eb808c15610bf87c3c872eb50cada63221803"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be0f892beefe8c24e5840498b5540a70d09352ae582514ff6fc0748c07618717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3d9ccbdd34f0ac06f2f2162068fe578f7749391c00d0cdae8d606ac7229ce1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73ea156810db6e58ed3bafee532dd28fda24b76b4fdd601fa9b490ff9b8e6a95"
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
