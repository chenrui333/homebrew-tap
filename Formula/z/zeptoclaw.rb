class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "66cbc952512890707a1ab50c26e59d93c382500b1c9a9e88974fef3cf647f29e"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "734ca13ac08a685351391364da606b20e396614ae5701f9f4a419e452b872ae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "997b9efb11c4149c736fe0b37f8b1c7a58955cea566ab609cc46f9099733d288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbf18cfe6234408fe53a7e47b251a7666d811cc35cd39c178d499507a71b86ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab4ed7f471f891e6e662efd891bede05a2eab4b7367c9e3a8a455b28cdeb303f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed3af41f55ff8fac1283a581cc343780b65efefa394a3f21b0e98ae6f63e47b2"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
