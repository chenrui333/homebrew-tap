class Pls < Formula
  desc "Prettier and powerful ls(1) for the pros"
  homepage "https://pls.cli.rs/"
  url "https://github.com/pls-rs/pls/archive/refs/tags/v0.0.1-beta.9.tar.gz"
  sha256 "bb3d4ee81410f8570e597ddb081ade0ac1a27b91400db2c3659704168c189bc0"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+(?:[._-]beta\.\d+)?)/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "286760b4e9dd852f2fc46796005adc6ca57dc3494c34cd94a8aa92f855839603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eff5d5190d27d2382205640f0c9640baed85720309de96dd4aeed9a03476854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a30c7cf3e3dbfdacd9255f5951e734101e330f12b327b46f1acb492b952de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96484dafbd99eaf19cac69d82785b60bc69c57476e3937643cf0f5358fb028de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b21bc2ee0f3599323e58879307113fe1bc52aa2967b60ecb87d0cc28cd49b77"
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
