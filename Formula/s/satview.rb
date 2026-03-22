class Satview < Formula
  desc "Terminal-based real-time satellite tracking and orbit prediction application"
  homepage "https://github.com/ShenMian/tracker"
  url "https://github.com/ShenMian/tracker/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "6c6c82ed9fd04a8509424c3dfb932e938f47b6e30c29a128855f305804bb4496"
  license "Apache-2.0"
  head "https://github.com/ShenMian/tracker.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args # artifact would still be `tracker`
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tracker --version")

    output = if OS.mac?
      shell_output("printf 'q' | script -q /dev/null #{bin}/tracker")
    else
      shell_output("printf 'q' | script -q -c '#{bin}/tracker' /dev/null")
    end
    assert_match "\e[?1049h", output
    refute_match "Error", output
  end
end
