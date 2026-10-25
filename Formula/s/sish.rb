class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "b8b8d202b0ff4632ff509baa83d15ba561c797871748de869ee1c536f34f1b3e"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a902b5ce5b03801894291937616b159d64b32a893429519cc95e5a285bf7b39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a902b5ce5b03801894291937616b159d64b32a893429519cc95e5a285bf7b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dc8e9fccf5f3ba5e0ca5f02c59a9635611c03c89f47555f1de94411867f9e8a"
    sha256 cellar: :any,                 x86_64_linux:  "9ac9926321db317e378b448b5435c2d2a8d2a0d802a032fcfcf4fbd8846b6ba6"
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
