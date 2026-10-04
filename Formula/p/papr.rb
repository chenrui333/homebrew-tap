class Papr < Formula
  desc "Terminal workspace for academic research"
  homepage "https://github.com/AfrozSaqlain/Papr"
  url "https://github.com/AfrozSaqlain/Papr/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e5648239d6632634bd3dfe2c504147f509f26224943d41c5272815b13e3ed81c"
  license "MIT"
  head "https://github.com/AfrozSaqlain/Papr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84433f445f1c21800e0068567c678330c02df8a65e06360ed54afd589fcd6445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed6a70a29ae73d5a74726851ba3ffce61332df0115c2a3f1052d8b1afd0025ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00eeac086ac797c58e610802a8513f2010052ba1fb321b9e8629e40c6459509c"
    sha256 cellar: :any,                 arm64_linux:   "5e6cb0d3f9085fb9f53b32c479c6478e59d4fb77a225e1a851b77af301ce9c00"
    sha256 cellar: :any,                 x86_64_linux:  "bfcd8d70bf483a9733dabfb5938fa5e8447c541ae44476c76775ae7652b6940a"
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
