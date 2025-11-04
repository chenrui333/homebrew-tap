class Wisu < Formula
  desc "Fast, minimalist directory tree viewer, written in Rust"
  homepage "https://github.com/sh1zen/wisu"
  url "https://github.com/sh1zen/wisu/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "3f2ed775b6b0050390a63d230847e4eb527f35ff058b79ed375236cf5e3e665e"
  license "Apache-2.0"
  head "https://github.com/sh1zen/wisu.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wisu --version")
    system bin/"wisu", "--info", "--stats"
  end
end
