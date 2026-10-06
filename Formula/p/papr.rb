class Papr < Formula
  desc "Terminal workspace for academic research"
  homepage "https://github.com/AfrozSaqlain/Papr"
  url "https://github.com/AfrozSaqlain/Papr/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e5648239d6632634bd3dfe2c504147f509f26224943d41c5272815b13e3ed81c"
  license "MIT"
  head "https://github.com/AfrozSaqlain/Papr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad42b42ff54e7d8df07824df04ce5ca2aef0300fa5afe6b17092760566e3051c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3295da651dce03bed547104e83c764691b8caa6723f5ed58b893f4bb95e39fc1"
    sha256 cellar: :any,                 arm64_linux:   "5e37c3f560766d9e5412a25c175530b289abc53cf71153b9c46147e4536ca5c9"
    sha256 cellar: :any,                 x86_64_linux:  "29c8f7e8b5301323851ff4ff2d67434893c05f30a651ad2fbfcddb817ce41a6f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/papr")
    generate_completions_from_executable(bin/"papr", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papr --version")
    output = shell_output("#{bin}/papr paths")
    assert_match "database:", output
    assert_match "projects:", output
  end
end
