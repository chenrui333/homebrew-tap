class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "5cef1a0acb3037b0cfce0db004a8423d114aa15c15e21efd99cf0dc2029f47e0"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66dc81a2e9d82e828742fce52ca722068ebe84b6008623d3044a6f34c1c7e838"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75fbfaa2d61fb5e23c8edeafcf72573577cb5ae317e41ddec428846ad1b42d5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67d4d4a6c327ed6f55169b33f7ef1c4441b929821211f5cd827ef80b44d8ff0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61e846e8588f653e028e5575c9db9647c4b86fea9b1b697b5a13ca0d4e6bcc90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcc81b9a599ef1a630ba77629644ab01863e00aa041c4092e7f608ecd1881666"
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
