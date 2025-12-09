class Termdbms < Formula
  desc "TUI for viewing and editing database files"
  homepage "https://github.com/mathaou/termdbms"
  url "https://github.com/mathaou/termdbms/archive/refs/tags/v0.9-alpha.tar.gz"
  sha256 "7ad5cfb55bcbf7dafb679ae1dfc63ac85de005de6f0a62f494a24f0782008240"
  license "MIT"
  head "https://github.com/mathaou/termdbms.git", branch: "master"

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
