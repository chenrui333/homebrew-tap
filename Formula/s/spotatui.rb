class Spotatui < Formula
  desc "Terminal music player for Spotify and local media"
  homepage "https://github.com/LargeModGames/spotatui"
  url "https://github.com/LargeModGames/spotatui/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "248d70668dddd28138c50ca8e4dff1499d08521288212d49f8e4a2a7348aa3cd"
  license "MIT"
  head "https://github.com/LargeModGames/spotatui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9c19c26297ac755bead0ec0b52e6712ec122af1c6dd1ecb191291fc11cc5d66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3352c258943f2052988dbf4e97b5042b21535c6c544a32ff5a0b4927e37899cb"
    sha256 cellar: :any,                 arm64_linux:   "068175df5a0600480c32923225fc0567ba4f84e7f2b859221ebfd0a67c7d1ae9"
    sha256 cellar: :any,                 x86_64_linux:  "fc95905aefb4759eb022fbdc2e43803de18c6e81cd3d4b78e50262f50c36f6e5"
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
