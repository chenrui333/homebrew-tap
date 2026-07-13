class BiberInspector < Formula
  desc "Binary inspector written in Zig"
  homepage "https://github.com/hrasityilmaz/Biber"
  url "https://github.com/hrasityilmaz/Biber/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e23b5de32d9c8ce277418c7bf7b71c26ab1a4b9f99ba1fb93d22943fd832bd5d"
  license "MIT"
  head "https://github.com/hrasityilmaz/Biber.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c5479b26838272980e1806356985cb0e23c1603d58a627107b12f58b826c35b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e8c8b255c1fe18af00f787221595240b626ebfdd0f9e23065f8884d6599f80c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df85be8debd80ad278f37a7593d6ebe82911b9e43053ad2b4825be567b902a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31f9921042653839e2f4526c379b192fc76d826b45e9daaa9595d34c9f6d8d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1447d6e51352461dd7de9b6878f0e35ebbd834303f4974a07b655192d47890"
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
