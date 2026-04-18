class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "db11902b3ed766123655f4348f76539bd245eaa1852ea9bca250d02e727dce29"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1545c552b7dfb0c579236edd2bf5e34e6293c69f90c05f401cb5e8873d2263e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f0e9897786b7192e8151de5021c49cee81026679b87221eb720e966ac19bf22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1859db5627b05c987cf0e1fc05182828f5192cd930d58364a04082e7b31cfa52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e68bd05dfafd9db3a7a31d5a7e4ce5a8d1f4a10182370849a142d98b4b90b1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03c96a1d0b9fa140f4295c48897928d22c0f25eabcf24efa4b497a1b22feb1cb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
