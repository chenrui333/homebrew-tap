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

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
