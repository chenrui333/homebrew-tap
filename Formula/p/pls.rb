class Pls < Formula
  desc "Prettier and powerful ls(1) for the pros"
  homepage "https://pls.cli.rs/"
  url "https://github.com/pls-rs/pls/archive/refs/tags/v0.0.1-beta.11.tar.gz"
  sha256 "d3893ed7c148a0821aa131dbe0214799a9dde8ded07243570fc41fe6bbaecfea"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+(?:[._-]beta\.\d+)?)/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bde8e9f34efb6650e7918e1c6eb804eee3f5e9ea511e1d40fc180216820e555b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "facbee40c10ea5637a732c003371059edddab295c2f7e1d7557272f836ff6989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1b99e73b399c54fd77e96ba159e0e18791cb06b0963f443dae14cd561904252"
    sha256 cellar: :any,                 arm64_linux:   "19733644054e8c234914f84133fafaa0da447eef1662ebcd39be8391cba36c1f"
    sha256 cellar: :any,                 x86_64_linux:  "133b257331bd461d32dc46c99403429bf070a1a56d866533a472620896620e2f"
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
