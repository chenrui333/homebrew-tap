class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "c2a4d39ffe58acc5ca23de622d2ac4f646cecc0d4bdb0b8e26f1cbc44aa98b82"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "373493f401ab39a41e272c78b1cc1143799e64863b45e993804530b35fd048e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "373493f401ab39a41e272c78b1cc1143799e64863b45e993804530b35fd048e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f31232386aa870105e475f125e72adecdff6f44a044299481b14268178df2770"
    sha256 cellar: :any,                 x86_64_linux:  "d8d2fd09b575189dbcc83f50409bb40bfa04f7ba8a70191e45d5263d0ae6ec0f"
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
    assert_match "notaport", shell_output("#{bin}/sish --ssh-address=localhost:notaport 2>&1", 1)
  end
end
