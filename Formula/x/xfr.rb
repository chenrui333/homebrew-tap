class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "a951427f7080623d90e044f2032d4fcaa394a457a1652e6ddce0be8b2ef17f20"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")
  end
end
