class Mln < Formula
  desc "Modern replacement for `ln`"
  homepage "https://github.com/tkmru/mln"
  url "https://github.com/tkmru/mln/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8d57a09b95be6bd24f7c7c90be19e6ddf94640d153fd157f41282ee64c767dfc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2084b88f5fa76753cad29416162ae480c2ffe2ccf42aa705ae1619cd9d97a08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2084b88f5fa76753cad29416162ae480c2ffe2ccf42aa705ae1619cd9d97a08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41c73357150e4949f234ff7f9b4255e16705bbdb5e84765653ffb77e6f177396"
    sha256 cellar: :any,                 x86_64_linux:  "1a7aaf0acac4e8987bef3b07e8e270ee638c0878063847ead1334d69dc251b02"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"testfile").write("This is a test file")
    system bin/"mln", "testfile", "testlink"

    assert_predicate testpath/"testlink", :symlink?
    assert_equal (testpath/"testfile").read, (testpath/"testlink").read
  end
end
