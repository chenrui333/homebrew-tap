class BiberInspector < Formula
  desc "Binary inspector written in Zig"
  homepage "https://github.com/hrasityilmaz/Biber"
  url "https://github.com/hrasityilmaz/Biber/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e23b5de32d9c8ce277418c7bf7b71c26ab1a4b9f99ba1fb93d22943fd832bd5d"
  license "MIT"
  head "https://github.com/hrasityilmaz/Biber.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baa32a360d30ea4087bbd5a782fb88ad82402269668fa152b46cfe80c1082cdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbf4eca398cedd449166e712822f437f5fa30b27ecd831f82dfc2384d9f2c829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "950c00e37f91dc83db78d4a7a4b564e800c0ba97ae8d2f8233f1a7019f6543b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ede2bc12e49afce165a2b97e6415e5d5d02aff73528a36a042307f98c343f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6345c98b7d847f996c41f4f9a90515344127a82fc574e84ebc346bf27e051e41"
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", "--prefix", prefix, "-Doptimize=ReleaseSafe"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    (testpath/"sample.bin").binwrite("biber")
    output = shell_output("#{bin}/Biber -f #{testpath}/sample.bin -dump 0 5 2>&1")
    assert_match "00000000  62 69 62 65 72", output

    output = shell_output("#{bin}/Biber -f #{testpath}/sample.bin -dump 99 1 2>&1")
    assert_match "offset outside file", output
  end
end
