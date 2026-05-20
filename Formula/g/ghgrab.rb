class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "4085a878d1a99bcc91431da7fc24b7825fec3293a2bbeb4a67a94561b798dca8"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64dcf1b132c4ab170fb0e9249ae7fc5950f321bbc825d819f46009d5953c926d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620023bc80b08dc5c1f2b9d9175e1bd346b2944e118434a1f9c3d3eeae02cfcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d37db35810a36b42ec61b4aa72d0a68200aabbae525b8730f95d5d3aa4f7979a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e2d6e0ae9a6f64a28bbe625d492279e532adbbcce42724ec7a33d2ea6893c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0323e5c1fca55c08dbd2bc53be57bd0f99e9a72204107066b5e4f7e01f21289"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "json"

    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    (testpath/"downloads").mkpath

    assert_match version.to_s, shell_output("#{bin}/ghgrab --version")
    assert_match "saved successfully", shell_output("#{bin}/ghgrab config set path #{testpath/"downloads"}")
    assert_match "Download Path: #{testpath/"downloads"}", shell_output("#{bin}/ghgrab config list")

    payload = JSON.parse(shell_output("#{bin}/ghgrab agent tree not-a-url"))
    assert_equal false, payload["ok"]
    assert_equal "invalid_url", payload.dig("error", "code")
  end
end
