class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "aeb1bdb4f2141ce981a1afba2e95cb604898b23345cf2f9b42689307220ee1a2"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7075ca6625f3039768d72e6e162c1261be5d5e396145de243447beb32618a229"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e57b2e68329528a3ee72842546de4830348324a75b7c9e0e472c5866282f0fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f152d82b896d500e9bce79a3359a475f440aad49e8f40e10c3abcefe32cfd172"
    sha256 cellar: :any,                 arm64_linux:   "7fb66484c2dc5ac01c2af0a21d41e7df5a92c30d032af17a358d310880008ac6"
    sha256 cellar: :any,                 x86_64_linux:  "ec8681453e0675ff8f2b06a58bbc4e00b5e10a7a59528a94fb8aeb03bb075159"
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
