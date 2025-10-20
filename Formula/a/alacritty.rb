class Alacritty < Formula
  desc "Cross-platform, OpenGL terminal emulator"
  homepage "https://github.com/alacritty/alacritty"
  url "https://github.com/alacritty/alacritty/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "b7240df4a52c004470977237a276185fc97395d59319480d67cad3c4347f395e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63dccd92b84e7f512c7243356b26ef0c32ebe2a597e4938d1f7d8ccce4b46c78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d90c26472ebcb6f162452098eddfe5f83592abf8e9704a0a580fb5348295131"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5bbd110c5fbea59dbfcb9650e6f08ace5aaad29434dd471b5f1ad43b1aa53ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7ace95f29da1611367488281839e4ff5f9a82aa0fd9c908c43661d9bb87d0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41ab0d975e056c35bf3d8c952c6f7822b3d88a93f2562bb2015d9078e4724a25"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "alacritty")
  end

  test do
    # it is a emulator
    assert_match version.to_s, shell_output("#{bin}/alacritty --version")
  end
end
