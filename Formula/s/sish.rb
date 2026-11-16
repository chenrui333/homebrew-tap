class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "c2a4d39ffe58acc5ca23de622d2ac4f646cecc0d4bdb0b8e26f1cbc44aa98b82"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57a47966e94b89473ec50ea1912f7e3eb8a022a868b80b0df7e5c9485dda48cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57a47966e94b89473ec50ea1912f7e3eb8a022a868b80b0df7e5c9485dda48cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0558ce98e377dab86daa2043650d892850eb9295c6c042aff7b83d9e801a25c"
    sha256 cellar: :any,                 x86_64_linux:  "203436b764532022eb882370b7fbfc3d73383deddcdd440b9578d4eea43fb75f"
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
