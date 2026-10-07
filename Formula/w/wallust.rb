class Wallust < Formula
  desc "Better pywal"
  homepage "https://explosion-mental.codeberg.page/wallust/"
  # Codeberg regenerated the 3.5.2 archive (same tag commit); pin the tag commit
  url "https://codeberg.org/explosion-mental/wallust.git",
      tag:      "3.5.2",
      revision: "b689616d630bb2e541695f101d313699464aac09"
  license "MIT"
  head "https://codeberg.org/explosion-mental/wallust.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd8fcd535adf8545763f6be3ec30b0184b72b320708ab98afb4a5d76a64afdef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a2f5051b4ac8d5b5a621741e2fe11e92f0c696de2a9a98a7934942808d9d93a"
    sha256 cellar: :any,                 arm64_linux:   "a68353a55d67cd145874aa269f536abc4a727266bd6e0ffe4c44f44888d71b5d"
    sha256 cellar: :any,                 x86_64_linux:  "3efb400ba8895ff29f322f551d85fbdfa2376b7838b3275c2526ad11ce8f40ee"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/wallust.bash" => "wallust"
    zsh_completion.install "completions/_wallust"
    fish_completion.install "completions/wallust.fish"
    man1.install Dir["man/*.1"]
    man5.install "man/wallust.5"
  end

  test do
    require "zlib"

    # Generate a small RGB gradient PNG locally instead of downloading a test image.
    rows = (0...64).map do |y|
      "\x00".b + (0...64).map { |x| [x * 4, y * 4, (x + y) * 2].pack("C3") }.join
    end
    chunk = ->(type, data) { [data.bytesize].pack("N") + type + data + [Zlib.crc32(type + data)].pack("N") }
    png = "\x89PNG\r\n\x1a\n".b + chunk.call("IHDR", [64, 64, 8, 2, 0, 0, 0].pack("N2C5")) +
          chunk.call("IDAT", Zlib::Deflate.deflate(rows.join)) + chunk.call("IEND", "")
    (testpath/"gradient.png").binwrite png

    assert_match "Saving scheme to cache", shell_output("#{bin}/wallust run #{testpath}/gradient.png 2>&1")
    assert_match version.to_s, shell_output("#{bin}/wallust --version")
  end
end
