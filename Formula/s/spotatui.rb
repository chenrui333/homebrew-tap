class Spotatui < Formula
  desc "Terminal music player for Spotify and local media"
  homepage "https://github.com/LargeModGames/spotatui"
  url "https://github.com/LargeModGames/spotatui/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "aa02120e2921bbb3958e71aa17a0653486724bc1458ed000be09cb374f37e8eb"
  license "MIT"
  head "https://github.com/LargeModGames/spotatui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70d984885c08843785fb53caed1b34106d2b4bed07e5ade85189fd4659421b5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "059c29efe0eeb4717a8053c290194ccce40d621429b5bf2bf72c537837e9d9fe"
    sha256 cellar: :any,                 arm64_linux:   "c47355b978d124e7afaa84204958729b3f0eb31a2f806de8e66860d1573e62ab"
    sha256 cellar: :any,                 x86_64_linux:  "96b5371d5ad15853a89aefaf86dea321f67248f87b06d508315121ea09f94436"
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
