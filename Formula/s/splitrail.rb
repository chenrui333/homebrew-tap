class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://github.com/Piebald-AI/splitrail"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "2be71728e1d888267c90131c299cd54c4754922183350ee66bd426fdd1019911"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb057608f49929c09a076d4b942b9e1cebf52e145c7ce67f31203619fab63e10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c6a2ebd0e891763e102e94852a53bb20d06b8fd4b74d317cfeff8174a8b4ca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae1d890c4e22c393acdeba60388442ac7d2ccc63281e8e442178db9ec0c5d727"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c94622b62488542d050c5d0bd336054d82815732ccd284f94e0797a25bd6f35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33ea05736f124d4e05f8816f7dff4afb980ca692eabb6e5c94b879341a37e5b8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")
  end
end
