class Myx < Formula
  desc "Terminal Spotify player"
  homepage "https://github.com/HaseebKhalid1507/Myx"
  url "https://github.com/HaseebKhalid1507/Myx/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "42c48a29910a44bca6eef52692a7f3774c80ceffed2c11c7a6b541b8cca645e3"
  license "MIT"
  head "https://github.com/HaseebKhalid1507/Myx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4b022236bb2d85e98183e605b9e7d219958cec404bd962bf98b5b4948236111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "905d2898d25d9fcb05653e8af725011d1cdd6c8a9c0aefbdb36660eb13fe50fa"
    sha256 cellar: :any,                 arm64_linux:   "ad67d7cd035215b654e79cba6db8faa86cb1633b7b15afeac9347cbcf055dde7"
    sha256 cellar: :any,                 x86_64_linux:  "f1216ecfb05df07e96d9ae34dcca07669a1eeda2fc8348e98c45d5d61de2beba"
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
    # TODO: Upstream does not expose a version command; add a version assertion when available.
    output = shell_output("#{bin}/myx theme get --format invalid 2>&1", 2)
    assert_match 'unknown format "invalid"', output
    assert_match "expected sh, css, hex or json", output
  end
end
