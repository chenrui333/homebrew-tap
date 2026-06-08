class Kyushu < Formula
  desc "Self-hostable Wasm sandbox for JavaScript workers"
  homepage "https://github.com/peterpeterparker/kyushu"
  url "https://github.com/peterpeterparker/kyushu/archive/refs/tags/cli/v0.0.5.tar.gz"
  sha256 "8a5bc77f15b191e0e7a78aac2755b800509a044bea5bf2013114f44274c97705"
  license "MIT"
  head "https://github.com/peterpeterparker/kyushu.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyu --version")
    assert_match "kyu", shell_output("#{bin}/kyu --help")
  end
end
