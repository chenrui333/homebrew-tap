class Ffdash < Formula
  desc "Terminal UI for batch AV1 and VP9 video encoding"
  homepage "https://github.com/bcherb2/ffdash"
  url "https://github.com/bcherb2/ffdash/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "61d8ef2cdb3d6b232df25eb05b375b72245b51ce00b3ce072612dae53b7382eb"
  license "MIT"
  head "https://github.com/bcherb2/ffdash.git", branch: "main"

  depends_on "ffmpeg"
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ffdash --version")

    output = shell_output("#{bin}/ffdash check-ffmpeg")
    assert_match "ffmpeg found", output
    assert_match "ffprobe found", output
  end
end
