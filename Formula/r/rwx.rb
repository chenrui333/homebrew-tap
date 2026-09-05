class Rwx < Formula
  desc "Manage Unix permissions and ownership"
  homepage "https://github.com/vncsmnl/rwx"
  url "https://github.com/vncsmnl/rwx/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "e7848a07e96fbed035e1ab3f32b6099a2c9457c7caa3863f97112cee57a9eae2"
  license "MIT"
  head "https://github.com/vncsmnl/rwx.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rwx --version")
    output = shell_output("#{bin}/rwx --invalid-option 2>&1", 2)
    assert_match "unexpected argument '--invalid-option'", output
  end
end
