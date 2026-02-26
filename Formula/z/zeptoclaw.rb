class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d88a4e289904463ff087d322b549343773098354b80faf71445a329dc5c0c2e6"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40d55d1778173bf0be917431a22320f783185a54c8c3265152e96e3ed7f9f905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c48ef514dbbffd439f8cbbdf510d24be0fa19c4d5a97adec3f7f6b6e57c6d53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d90f6c013707361f4e8b1a2d19224647443367f8c59c0225925f258adf39139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "547becc5f9f8ff18fbfdfc2f21bfce6048437241b8f3b5a8cb274fb9cefc430f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e346a8f55a9f05ed463e7aaf74d1fabc29bcf87370b59c841f19cc3900b01c0"
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
