class Intentrace < Formula
  desc "Better strace(1) for everyone"
  homepage "https://github.com/sectordistrict/intentrace"
  url "https://github.com/sectordistrict/intentrace/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "21044f0556cb439986771a5ff18d8ce470da61b49e5dc558badb726844473250"
  license "MIT"
  head "https://github.com/sectordistrict/intentrace.git", branch: "main"

  depends_on "rust" => :build
  depends_on arch: :x86_64
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intentrace --version")

    output = shell_output("#{bin}/intentrace --summary -- true 2>&1")
    assert_match "EXITED", output
  end
end
