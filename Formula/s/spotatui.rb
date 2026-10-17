class Spotatui < Formula
  desc "Terminal music player for Spotify and local media"
  homepage "https://github.com/LargeModGames/spotatui"
  url "https://github.com/LargeModGames/spotatui/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "d1ad76c8a6f5938a86e8fed0994170aaeee19bc5782ea1efbea45e186e05f28b"
  license "MIT"
  head "https://github.com/LargeModGames/spotatui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcb7563e177457065e03c3a73e600e4f04575e2e49c424b9ae254c9fab587a76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06d0db40967294e6926f7c2cb19b61cb51f2aed50942bce88c4fa41bf7b12e3"
    sha256 cellar: :any,                 arm64_linux:   "be51ebae402264949a2a004cc23d6b7e84d388509f5efb9ca58be70518e41b1d"
    sha256 cellar: :any,                 x86_64_linux:  "1acf77fefe9c9d6c6cf710a6b1751edc19e32f32f767c69b19897c076d005370"
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
