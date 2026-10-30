class Hax < Formula
  desc "Minimalist, terminal-native coding agent written in C"
  homepage "https://usehax.dev"
  url "https://github.com/OleksandrChekhovskyi/hax/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "de63efaadb9b71879b9a084a9e8aa863eb98e893b83c0a4ab8a465f97c8594e6"
  license "MIT"
  head "https://github.com/OleksandrChekhovskyi/hax.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f79f04087ad02d355de6a0efe68f9e1f9c3f5b84d2f8066f84d051185c25dd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46ced698efd279ac9ea12948b0ab302b64c14bb6f6f74ccdc6572bab47eff009"
    sha256 cellar: :any,                 arm64_linux:   "096850624ddc611cdde63d4d4b830247b14c7ee06e93924df9344a4526639c56"
    sha256 cellar: :any,                 x86_64_linux:  "22aa1a4ed20c58ca993f7f9fb46112f6f73d430e54a552818cffda90f13533d6"
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
