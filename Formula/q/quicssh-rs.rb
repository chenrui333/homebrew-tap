class QuicsshRs < Formula
  desc "SSH over QUIC"
  homepage "https://github.com/oowl/quicssh-rs"
  url "https://github.com/oowl/quicssh-rs/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "1e1b98e67598e2ee1c3704c75072b9e120a0ec21f70ad2cd1d2c5918d68a57b8"
  license "MIT"
  head "https://github.com/oowl/quicssh-rs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b991cb7294451b4f8191a7389541551b0d0af90154660001be95370004971366"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b0786c5d0ff3e2bd954773dab438869d160b2a5b0fc4d1e31e9ad414fafda46"
    sha256 cellar: :any,                 arm64_linux:   "7b8ff916413bc05b03f55ea3d748af501c81b3a64d8f327b7c73d30f3499633d"
    sha256 cellar: :any,                 x86_64_linux:  "0c6e3af91c85ba9af43f1d255f8f8a8e91ff9ade68e0a3991654c8cdb25ea072"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quicssh-rs --version")

    # The server binds a UDP socket, so exercise the client's offline URL validation instead.
    output = shell_output("#{bin}/quicssh-rs client ssh://127.0.0.1:4433 2>&1")
    assert_match "URL scheme must be quic", output
  end
end
