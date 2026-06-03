class Pls < Formula
  desc "Prettier and powerful ls(1) for the pros"
  homepage "https://pls.cli.rs/"
  url "https://github.com/pls-rs/pls/archive/refs/tags/v0.0.1-beta.13.tar.gz"
  sha256 "3180496894ccff226c4f68346bd4594e6207928dbbd8fff2e9960126be14a1cc"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+(?:[._-]beta\.\d+)?)/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83e2d9703db12162d09973f58c69b62f0e14901e6c3bc49b9113d208bc6de7d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f131f4a907587868149d3170bba7b1e642807ecd89c982298bf18f25fe281a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdcc0385e822a073a14d93a8d9ae7a32c9ec0df84352c92adf6a011f3265faba"
    sha256 cellar: :any,                 arm64_linux:   "2f7da9d6d81536b84b57bfdc34f9595a4f6fac7523b6741170f8bad80deceff2"
    sha256 cellar: :any,                 x86_64_linux:  "cc6b9f3735790bda1008235fd1d9acbaccf5bf6ad10ce7d03d0197644c479d42"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pls --version")

    (testpath/"testdir").mkpath
    (testpath/"testdir/file1").write("This is file 1")
    (testpath/"testdir/file2").write("This is file 2")

    output = shell_output("#{bin}/pls testdir")
    assert_match "file1", output
    assert_match "file2", output
  end
end
