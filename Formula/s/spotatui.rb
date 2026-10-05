class Spotatui < Formula
  desc "Terminal music player for Spotify and local media"
  homepage "https://github.com/LargeModGames/spotatui"
  url "https://github.com/LargeModGames/spotatui/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "8429bb068dadb9d3e4206c8220a185a745379c1327efd2b71adfe595558ed4d5"
  license "MIT"
  head "https://github.com/LargeModGames/spotatui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "696c21458e657c3bc63122546d7b8f7e4756a695c143ef8d42bcc7b6b85487c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f9a6360f22febd8987f2f8e70593ab3aa1e34d7bf1ceedbdd871a3b075ccd5"
    sha256 cellar: :any,                 arm64_linux:   "0d117126bd23ff93a8d4863a9b2dfc334401c00e7722d98482ddc68d076c0b38"
    sha256 cellar: :any,                 x86_64_linux:  "7e65f6ecb00d87bd875bb1b540455bb74520530d0466525f9f8072414421bfaa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"spotatui", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spotatui --version")
    output = shell_output("#{bin}/spotatui history recap --output #{testpath}/recap.html")
    assert_match "Generated recap from 0 qualified listens", output
    assert_path_exists testpath/"recap.html"
  end
end
