class Spotatui < Formula
  desc "Terminal music player for Spotify and local media"
  homepage "https://github.com/LargeModGames/spotatui"
  url "https://github.com/LargeModGames/spotatui/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "563aa915f4bd47c9f9647e405885ccfb97f69a0e6422e3223a030a2f77dbec59"
  license "MIT"
  head "https://github.com/LargeModGames/spotatui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "747fa1831ebcefee85f8429fc142e48a61bf2c2f6ea46a9af1a905f9ae2635f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69855b8eec0ae94b5b7c88638c942919c505910d431956eb74e3828646861471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "744df65562acbf6b1a3a3aff188447ce97d2f1249e04c3998774be6aa4b1c488"
    sha256 cellar: :any,                 arm64_linux:   "aca41e86047a9e8e62c864b25cf97b91cf034da38d7b4fd8ed68ddd6e4f4f18d"
    sha256 cellar: :any,                 x86_64_linux:  "714042599ec641f318317783a20bb5e47c0e9c8f71c38a6413e675c9f85be278"
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
