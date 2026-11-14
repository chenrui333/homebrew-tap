class Hax < Formula
  desc "Minimalist, terminal-native coding agent written in C"
  homepage "https://usehax.dev"
  url "https://github.com/OleksandrChekhovskyi/hax/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "46c40ee15ab7ce6e6ff08d3b0e61ac858cf7b0af91c9167d5e79897e7bc92d2e"
  license "MIT"
  head "https://github.com/OleksandrChekhovskyi/hax.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8108d7ba9ed09d924ea343b8ef1f1a70b0e4eafb960a85da1d1723684e96910f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9023b0378621c33a640f7baa7b6daa3963d81c2e189bc2b3349f97af2b4c456"
    sha256 cellar: :any,                 arm64_linux:   "cda890c665806b73fcb6a9165dc9d88352d542f8612fb8b869027abd37a682cc"
    sha256 cellar: :any,                 x86_64_linux:  "c225bcad629e3b8dc6df11cdc35263f879f39273268c0710bc8b57f1347f1c58"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"

  uses_from_macos "curl"

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hax --version")

    output = shell_output("#{bin}/hax --provider=homebrew-invalid -p hello 2>&1", 1)
    assert_match "unknown provider 'homebrew-invalid'", output
  end
end
