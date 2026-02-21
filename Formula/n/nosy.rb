class Nosy < Formula
  desc "CLI to summarize various types of content"
  homepage "https://github.com/ynqa/nosy"
  url "https://github.com/ynqa/nosy/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5f830d6398868540a0168aa3f0fbf38c2b85657f3d2af27ccaa51128b817f646"
  license "MIT"
  head "https://github.com/ynqa/nosy.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
    generate_completions_from_executable(bin/"nosy", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nosy --version")
    assert_match "nosy", shell_output("#{bin}/nosy completion bash")
  end
end
