class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "787882739305d4c97042dbbd2200737ffb314173e22389bb297ad31c710ea6bc"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a086dd80bc8bdbfe6a975bde1c52b3e1f2ed6367cca2dc19e1ffb43fc93ef4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a086dd80bc8bdbfe6a975bde1c52b3e1f2ed6367cca2dc19e1ffb43fc93ef4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d19b69368ded808ff514cc95b04221961fe8c93601c74f012d1208026a168efe"
    sha256 cellar: :any,                 x86_64_linux:  "eab9649b5d40d1ac3d66c57d8dbd3fe1df36aa602b65097cf20a0574f44b32e7"
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
