class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "5beeb268818bdf545b4bcd30d47d7079d7100cc63214ddd4d58d00a3fb0ea9a7"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3206073c69d3d2ebdddb98b878c46a9ab76b21414f26bb830b033e2c640ccb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "433ce75a596b7f2571f352d219660a90bb97ec2144ac698ed45b27ee75abbcbb"
    sha256 cellar: :any_skip_relocation, ventura:       "682512529ad2db6b6febdf0f16214d5b2f1ba6301b9d6f05700dd494dd8d823b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afbfb6a0c05902263f64a54d8cce1d5b320ead37da7e51f0a352bb1be7d7acc6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paq --version")

    (testpath/"test/test.txt").write("Hello, Homebrew!")
    output = shell_output("#{bin}/paq ./test")
    assert_match "eb9122ffff587d1cb9e56682d68a637e8efaa6c0cd3db5d90da542d1ce0bd2c2", output
  end
end
