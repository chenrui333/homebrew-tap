class Papr < Formula
  desc "Terminal workspace for academic research"
  homepage "https://github.com/AfrozSaqlain/Papr"
  url "https://github.com/AfrozSaqlain/Papr/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e5648239d6632634bd3dfe2c504147f509f26224943d41c5272815b13e3ed81c"
  license "MIT"
  head "https://github.com/AfrozSaqlain/Papr.git", branch: "main"

  depends_on "rust" => :build

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
