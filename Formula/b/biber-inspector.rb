class BiberInspector < Formula
  desc "Binary inspector written in Zig"
  homepage "https://github.com/hrasityilmaz/Biber"
  url "https://github.com/hrasityilmaz/Biber/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f61bda38a0d903ce5b28ca5b18e32bb336d971b6a7f4b948ed0089c0c9575e70"
  license "MIT"
  head "https://github.com/hrasityilmaz/Biber.git", branch: "main"

  depends_on "zig" => :build

  def install
    system "zig", "build", "--prefix", prefix, "-Doptimize=ReleaseSafe"
  end

  test do
    assert_match "Biber", shell_output("#{bin}/Biber --help 2>&1", 1)
  end
end
