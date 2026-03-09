class Aim < Formula
  desc "Command-line download/upload tool with resume"
  homepage "https://github.com/mihaigalos/aim"
  url "https://github.com/mihaigalos/aim/archive/refs/tags/1.8.8.tar.gz"
  sha256 "5500e38e48e381557847d09e42dbb093e1e402eb2c2965929cbcdae69ce9ec9e"
  license "MIT"
  head "https://github.com/mihaigalos/aim.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf0cf71ebf3bcb9712333e8778d0fb8630ce6835f6202dda5f5a28ecec7e7227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac5ce1cace76b95765ede24599206b3797ed6e8206b87d1ea265f47e49bed22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "484268f126cf8d806192fa37fb6d323c0fd9b10577fd8580850a1b8d1a03c52c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a0c89556898916f1615118e3f1bdbbf1d1393e60a17dd3698537ded3feacb57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1de00db98b18fd340f83e9f623f3187890c59a965bf1cd4fe0ad2f17da0fdec3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aim --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"aim", "test", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Serving on:", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
