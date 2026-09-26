class Spotatui < Formula
  desc "Terminal music player for Spotify and local media"
  homepage "https://github.com/LargeModGames/spotatui"
  url "https://github.com/LargeModGames/spotatui/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "563aa915f4bd47c9f9647e405885ccfb97f69a0e6422e3223a030a2f77dbec59"
  license "MIT"
  head "https://github.com/LargeModGames/spotatui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97ff83a3722fefa560b7d3c5684c6fc9b1b65dc502897df5a5a5b7cb45ce7d34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf22f6bed12dfaecc086720c061578f71f9cda6e6381fc41eba3d4e6eb359156"
    sha256 cellar: :any,                 arm64_linux:   "d372f6aae0292f5101a46c669afac998de7cd2c3ffb64c3ed58e7a3f8763f800"
    sha256 cellar: :any,                 x86_64_linux:  "f25029507e1aeca489e62dd8c4544a1e8824c31905072ba2d44c4ae3969cc41d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
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
