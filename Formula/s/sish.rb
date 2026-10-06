class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "48cd78c11bf39a0433b3555b8fedaa3de20ac7762f1b67105c347a0968096adf"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24c3cbb9a1ca6f8aa2bf4938f450cc76d7912d1ecbb0f328397238a5bd62a913"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24c3cbb9a1ca6f8aa2bf4938f450cc76d7912d1ecbb0f328397238a5bd62a913"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3ae39fec82399ffa2a57d3eb550ecf4ba403640bad429447aba3d919f3e7503"
    sha256 cellar: :any,                 x86_64_linux:  "de7140b46a4adaa4d360562688cdb73251ad69ad2941793213ff60cfef84a9d7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/antoniomika/sish/cmd.Version=#{version}
      -X github.com/antoniomika/sish/cmd.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sish --version")

    # Listener addresses are validated before any SSH/HTTP listener is opened
    output = shell_output("#{bin}/sish --ssh-address=localhost:notaport 2>&1", 1)
    assert_match "Error parsing address", output
  end
end
