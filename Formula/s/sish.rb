class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "48cd78c11bf39a0433b3555b8fedaa3de20ac7762f1b67105c347a0968096adf"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "663dccf17a092321656802a1de591bdb1fabe7579bd9fc0f9ddb18673a0eb2be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "663dccf17a092321656802a1de591bdb1fabe7579bd9fc0f9ddb18673a0eb2be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18545ad6a825ebf3c7781c25d70713e832b915208f2be7366efd08ec68236b3c"
    sha256 cellar: :any,                 x86_64_linux:  "d09a39ac81aeb9734295a24e5f40c073da7c7f83fc22ebc4d37ece407beb78fa"
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
