class Ec < Formula
  desc "Terminal-native 3-way Git conflict resolver"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "9093607b10bf080f4d1ab92898e1b3b9af8bfb67049775ce3d4daaae3fd28d27"
  license "MIT"
  revision 1
  head "https://github.com/chojs23/ec.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ec"), "./cmd/ec"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ec --version")

    (testpath/"base.txt").write <<~EOS
      line 1
      base
    EOS
    (testpath/"local.txt").write <<~EOS
      line 1
      ours
    EOS
    (testpath/"remote.txt").write <<~EOS
      line 1
      theirs
    EOS

    merged = testpath/"merged.txt"
    merge_cmd = "git merge-file -p #{testpath/"local.txt"} #{testpath/"base.txt"} #{testpath/"remote.txt"}"
    merged.write shell_output(merge_cmd, 1)

    system bin/"ec", "--apply-all", "ours", testpath/"base.txt", testpath/"local.txt", testpath/"remote.txt", merged
    assert_equal (testpath/"local.txt").read, merged.read
  end
end
