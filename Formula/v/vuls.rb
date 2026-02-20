class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "3eb670b85031f72dd0b18657d2a2a935617a74c9deac24876abc0b950cb64b84"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f32f5923e025a297fc315be648edf3ce5f6eeafe9b484ba61b34d0138bda607"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bc7f3cc7d4b2298b2eb8f5a72c4a370fecf9593228eb76626658bae25c14606"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68814cc04f2d0005cf5bc20c41ce04dbf6bc70d769d79833b1be0e36683153ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de211096f37c01ad14ae4e2a48414a51db6882ba15f0616769ccba2ba7f16a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9d3d89ff3bbaa2163eba74e3660aec705eae83c1a82346591a3453aece50d3a"
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
