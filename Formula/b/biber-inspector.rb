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
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    (testpath/"sample.bin").binwrite("biber")
    output = shell_output("#{bin}/Biber #{testpath}/sample.bin 0 4 2>&1")
    assert_match "00000000  62 69 62 65", output
    assert_match "[ERROR] Not supported", output
  end
end
