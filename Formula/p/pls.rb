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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efd5ac22d746a8161ec5032b8c40739f40c4a2ce129a89f51a910a82fe26a489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8611f96a5f6270658b08fc26767a46537c17f5506121074b318f1939d93ce1c"
    sha256 cellar: :any_skip_relocation, ventura:       "5153126f221acd8b360d35f0ed19e217420fec7314096dc549c7a713274a87fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbcab0d216cfd82b019700a4c31bdb90501457dbb12ca0d8f6c38d22c61d5ce9"
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
