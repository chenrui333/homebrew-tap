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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c61d79b5d29648b25ec4a338a3b49da7bf9fa99282c0d512a25ae9aebb01b6f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7b8d90e3ffc3975cfcafa71ed7e2917e60e081d1d7e46e953dd0a976b34eb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3602d593ff125a1149fbd34b4aeca7c417285e7a4fb6d9b491048930521177e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ba30fa72a90e2c9d2f2ff71c615a7832095357f60d70cba111a5ab1dec7675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7230f7f3e71d7de219cf5ff73ec33de54c9fd6d1e4185ceee160c46337a82f79"
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
