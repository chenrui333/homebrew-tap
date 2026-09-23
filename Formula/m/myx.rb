class Myx < Formula
  desc "Terminal Spotify player"
  homepage "https://github.com/HaseebKhalid1507/Myx"
  url "https://github.com/HaseebKhalid1507/Myx/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "42c48a29910a44bca6eef52692a7f3774c80ceffed2c11c7a6b541b8cca645e3"
  license "MIT"
  head "https://github.com/HaseebKhalid1507/Myx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c0ec957e14e0ab4d9164a975d5c6eff58ad7534e81f2705c1bf88e447da77bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "582b9f08f0a97021131ab417054f09eba3a71cb2cea4da5426a1f82847111f0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa11231120a51d4fb189d291cd17f0c1e2fe389e717848322a6fc91eaac4c0e0"
    sha256 cellar: :any,                 arm64_linux:   "a609faa082543a24c1086beb54fc7a5639dfd199a16a9dc3c17a69a787796001"
    sha256 cellar: :any,                 x86_64_linux:  "8271ea5c2bf7138abd45b0c7fcdd0e765031a77c06047e1ffe8a987bf0c27e44"
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
