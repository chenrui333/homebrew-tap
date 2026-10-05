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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b276b0d7cf7117c7e322f877e7877fd921f1f5a185629e659a2cf0af7ddd012a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c4af12dad6b39a05accb551e5b45a277e1053a8b2d6f9aaf5c38cc0898af777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8579fe4c620f6f63fca82b33a0ea96f79c200c857e6a90106c39e20bf50b1e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f05339d3809a3c682dbeb1db6bdde0ccef8a462e9c4673f025a87ab4563a0b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e3fa4953127c06c69a9d4b0a6ad1e43804f2b55cb480f3c3e2c1d64ab525fb"
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
