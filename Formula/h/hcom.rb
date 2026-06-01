class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.20.tar.gz"
  sha256 "4e7725ab31b650c4bb5eb9c03490de8dcf516f361a890aef56fef217868a7a78"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a9b23a976e1218db1ffbc444ff07c0bf4c64ee8fb8048d903e1dae3c31a3be3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01ee2ff107f8562f2d38960d6106b20d4281ae998ec023bc645435a71f42274e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ddb44d74da966f1f4334b4719d7fe127077cdabbe069101606cb2c1690d362"
    sha256 cellar: :any,                 arm64_linux:   "14447b8c691ec032e558653c1cca1212d53b3f50dbaa134d4541f63da80a4bb9"
    sha256 cellar: :any,                 x86_64_linux:  "676b26397952199e885644fe231f75bbfa329222d7496857b3627f8f191802d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
