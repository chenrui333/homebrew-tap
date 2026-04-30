class Pitchfork < Formula
  desc "Daemons with DX"
  homepage "https://github.com/endevco/pitchfork"
  url "https://github.com/endevco/pitchfork/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "178ddcb3220c87fce1b0407d1fcfb621ea108d79c1251b5baceb5b35abe23ead"
  license "MIT"
  head "https://github.com/endevco/pitchfork.git", branch: "main"

  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    (testpath/"pitchfork.toml").write <<~TOML
      [daemons.test]
      run = "echo hello"
    TOML
    output = shell_output("#{bin}/pitchfork list 2>&1")
    assert_match "test", output
  end
end
