class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide/archive/refs/tags/0.22.0.tar.gz"
  sha256 "af3f5894a3447e6271187a5eb65dc7c193542049f594b5f3864bc4e2e70fe834"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "3e3ebb6715d705c6e439edeef4eeb34bc87a70089aae00ebcf8432e4b3ddc27e"
    sha256                               arm64_sequoia: "8362bc74a82c986b7a1b75355e96cc53cda4a74daf208ca1b995a87e1febfc50"
    sha256                               arm64_sonoma:  "65addafc9da9baf1ef83cc351d0165ed613ed63f2ab6d23484e530ddc9a22b91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f769ebef012dac61a48595d8bfe910952a1610fe873790305df6a1a2afc20474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e03a5ae7c328d5794131d3708ad442d03040c2be42df3fda61518848a7c73f6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termide --version")
  end
end
