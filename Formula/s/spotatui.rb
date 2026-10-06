class Spotatui < Formula
  desc "Terminal music player for Spotify and local media"
  homepage "https://github.com/LargeModGames/spotatui"
  url "https://github.com/LargeModGames/spotatui/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "8429bb068dadb9d3e4206c8220a185a745379c1327efd2b71adfe595558ed4d5"
  license "MIT"
  head "https://github.com/LargeModGames/spotatui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c439e2bb8462e3ad27142d9fdf333404e33ec384094ffff61a5ecd137b11cfbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c8f21c91db1598f81a7ef1ab52e26a34523cf66db40a6f99105d3e81ec9f75b"
    sha256 cellar: :any,                 arm64_linux:   "aaf1a162496f0ae351d764c7421a7ec4266aa21ad7a021b8905f13b36512873c"
    sha256 cellar: :any,                 x86_64_linux:  "8f24c0706b855bd253cd5b8675a468b1f48b921aee94aa640c7301e5d0bdf8de"
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
