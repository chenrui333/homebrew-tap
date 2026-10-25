class Spotatui < Formula
  desc "Terminal music player for Spotify and local media"
  homepage "https://github.com/LargeModGames/spotatui"
  url "https://github.com/LargeModGames/spotatui/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "18d0c433ca96a1744621f900edcc7d90cdd4bb5352e16dc6abd7a2a87716759d"
  license "MIT"
  head "https://github.com/LargeModGames/spotatui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1c59894453178267e7188f769d5cfc9776d6996c8aef1a5609b16b993240685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f977d03f1f22065b4ff361ad3e092c35d86565fac3040fd465ba0b9a38c1f884"
    sha256 cellar: :any,                 arm64_linux:   "896db900f55af5274915fa3ab3c123f4785473a19a6cf0a9fc716a6409487de9"
    sha256 cellar: :any,                 x86_64_linux:  "584bcf4eec6b2699d13165cb9c7f0c626d5a27ecef890fe0a9599588428cede5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
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
