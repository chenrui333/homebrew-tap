class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "493c126c6e9681ca5fc4beb7816e3943471e9635c2e39a718c9ffd986f9ed9d7"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc18cef76d102afe1c91257da7c6a869e9df09ab17382ef9195e8af0eb6326fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc18cef76d102afe1c91257da7c6a869e9df09ab17382ef9195e8af0eb6326fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "171a6b9f8d8a977760d229ffe85c7f8728127c4ceab6307f2b13fc6767a0a58c"
    sha256 cellar: :any,                 x86_64_linux:  "20143de8d0c87cb73a101a9671df06ebb22a76f19d3e14380b4cd694980e0623"
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
