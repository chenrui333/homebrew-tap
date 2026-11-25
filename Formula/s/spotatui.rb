class Spotatui < Formula
  desc "Terminal music player for Spotify and local media"
  homepage "https://github.com/LargeModGames/spotatui"
  url "https://github.com/LargeModGames/spotatui/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "39b73bbd9c098aa9a0d050a2b8ebc157908861fceb9684b719963383179fc6ed"
  license "MIT"
  head "https://github.com/LargeModGames/spotatui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "bc8319ce692887b6485db4186722e60ee62b6f186ffa04b15e714e2625fdd05b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3a1367cfb0e7eb768918b08180af58c938439d8ba81247f924d6911bc2d9949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1271da3b7b7e69eba450f9c0fc08d5579b4385159d51d8c0864434446d42b30"
    sha256 cellar: :any,                 arm64_linux:   "eea9300a0a8591c3b239271768bca97030f8bffe6f08199c568678d5af56a680"
    sha256 cellar: :any,                 x86_64_linux:  "679c5d0235d90a2efa9a043c950316034d86e3d6665943b1d475f095f331e0a6"
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
