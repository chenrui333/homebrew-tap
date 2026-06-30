class Pls < Formula
  desc "Prettier and powerful ls(1) for the pros"
  homepage "https://pls.cli.rs/"
  url "https://github.com/pls-rs/pls/archive/refs/tags/v7.0.0-beta.1.tar.gz"
  sha256 "3489b5eb0b1d66c6511cf97d47bb098351ea12073ea001e23d0eeeb3b45a3311"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+(?:[._-]beta\.\d+)?)/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52223ceb929da82a44f6514c2907e887cf3e72d67be95fc9bc0456e03e67cc84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b7e22fa43bbb9a5207f4e244a4e138d85b188c2a02d2080f1b0182a17390b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "778eaa72274f6bdad8e6096a5b8b1a81e0b08e4cde3729f7a2f3d28f17930153"
    sha256 cellar: :any,                 arm64_linux:   "144ed137920cd2d66bd338a57c8fe74195d40f68dc6fc36fbc99c788cb6f9dba"
    sha256 cellar: :any,                 x86_64_linux:  "5b6f4c1356544dc83cdf765453fd6b48d0952fae323ab3cc2bde63bda1f5aa0a"
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
