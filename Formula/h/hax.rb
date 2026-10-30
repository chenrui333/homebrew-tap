class Hax < Formula
  desc "Minimalist, terminal-native coding agent written in C"
  homepage "https://usehax.dev"
  url "https://github.com/OleksandrChekhovskyi/hax/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "de63efaadb9b71879b9a084a9e8aa863eb98e893b83c0a4ab8a465f97c8594e6"
  license "MIT"
  head "https://github.com/OleksandrChekhovskyi/hax.git", branch: "main"

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
