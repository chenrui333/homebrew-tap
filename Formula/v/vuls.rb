class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "be6fa9401085307153a618caccf0626c226027f86299336b0915ded71a60c119"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f5fe8da9d7d266ca2cd187b47c24aa610ddbe3bd3062423fad4444d55522fd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8be8b5132122fad1447eee7020b6387015887a34732bd8de8602dbf3a3e10f43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "810cd007da5ce4afb3c84ee13edb410776ba64f56a64649480d426ad5d5c5b24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f855d5d1c48a61e653652faa55daa8b792ac670809719b62816917217142825d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaeb3c948b64ca24d33b603be3b35d5148b056165ef05491e2411d113609c9b9"
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
