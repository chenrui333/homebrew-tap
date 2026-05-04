class ChessTui < Formula
  desc "Play chess from your terminal"
  homepage "https://github.com/thomas-mauran/chess-tui"
  url "https://github.com/thomas-mauran/chess-tui/archive/refs/tags/2.6.2.tar.gz"
  sha256 "414a2b03751864cef59e7e3bd6fd8c9568a876a57d4b8605eaeeee1dec3cc625"
  license "MIT"
  head "https://github.com/thomas-mauran/chess-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aac2198ad0b7f85f35ef7f17236e155d2f188d02ddbc92826963667c20843bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f30e750946080a94c5000672fcb19d046d9b6719b5da1941b993da1033a62a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4608d2b056e96dc683bedd9a0d01dd970c07d342a0da4a195fd29232b8595ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccba76977322a9bea5f02dd14109fd6fbd416faf0a97c0162e20af0bf4bf41e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cc2f2d85b23571bd9853520a0838b22c1d8d2a8b2c1df7857f5e6895db90b70"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chess-tui --version")

    output = shell_output("#{bin}/chess-tui --update-skins")
    assert_match "Created skins.json with default content", output

    config_root = if OS.mac?
      testpath/"Library/Application Support"
    else
      testpath/".config"
    end
    assert_path_exists config_root/"chess-tui/skins.json"
  end
end
