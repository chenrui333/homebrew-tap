class Alacritty < Formula
  desc "Cross-platform, OpenGL terminal emulator"
  homepage "https://github.com/alacritty/alacritty"
  url "https://github.com/alacritty/alacritty/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "b814e30c6271ae23158c66e0e2377c3600bb24041fa382a36e81be564eeb2e36"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3506ced68adeb18bbe13af0f8439e794ec7a11f8c130902041b6a8939ee6efa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f305843fb583c756fdf54dd3b105732e572e701faf221d7f6ec7d0fce84e39d"
    sha256 cellar: :any_skip_relocation, ventura:       "4fd3745a056b88410c91018f6759c2f4dc262b90ec4452d9d10844c5688f4d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fc62edb141c618655fa13b630fbfccc220daafa02abd64f80f64e37d1d0cfa9"
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
