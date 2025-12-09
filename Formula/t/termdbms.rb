class Termdbms < Formula
  desc "TUI for viewing and editing database files"
  homepage "https://github.com/mathaou/termdbms"
  url "https://github.com/mathaou/termdbms/archive/refs/tags/v0.9-alpha.tar.gz"
  sha256 "7ad5cfb55bcbf7dafb679ae1dfc63ac85de005de6f0a62f494a24f0782008240"
  license "MIT"
  head "https://github.com/mathaou/termdbms.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b5f33d62003cdfebc5f04c266e7fbeea40161e65390b780e0fa543989d5dbb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b5f33d62003cdfebc5f04c266e7fbeea40161e65390b780e0fa543989d5dbb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b5f33d62003cdfebc5f04c266e7fbeea40161e65390b780e0fa543989d5dbb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "005d382f49c1732e6e60fd4cb7354e7f11df666e43c9c1177d3e9ae62fd15228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "408994632cca6b5089dfe1dd0678897ef0cb80330c43f97c9538e80fb37d88e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.csv").write <<~EOS
      id,name,age
      1,Alice,30
      2,Bob,25
    EOS

    output = shell_output("#{bin}/termdbms -p test.csv 2>&1", 1)
    assert_match "ERROR: Error initializing the sqlite viewer", output
  end
end
