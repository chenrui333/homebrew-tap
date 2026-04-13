class Alacritty < Formula
  desc "Cross-platform, OpenGL terminal emulator"
  homepage "https://github.com/alacritty/alacritty"
  url "https://github.com/alacritty/alacritty/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "38d6527d346cda5c6049332a1f3338a89ea66cd7981b54d4c3ce801b392496f8"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2a7576a36bb4af7e53567c3d5740da315f081c38698c5c18864c38645db3a74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd792b3f59812f9fc70abf44d14d83e15074c4be4b7c7f4c34502c507c267d97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48baefdb79515b4b87ceced94aa1172c2f93ac7a3d42f4c789f1b0aa01084207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac1b9815c13de299e916b83dc1ef98698594eed29d852a5baa57a78d34ef656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e04ab7410ec38b924c0e2d979cbde1d59739ee7d89af8f52b776b2b24d26a1ba"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "alacritty")
  end

  test do
    # it is a emulator
    assert_match version.to_s, shell_output("#{bin}/alacritty --version")
  end
end
