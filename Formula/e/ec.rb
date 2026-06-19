class Ec < Formula
  desc "Terminal-native 3-way Git conflict resolver"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "9598d57cd71c35c057ce92fda690380e3a138b44404ef14cbedf9f577772b71b"
  license "MIT"
  head "https://github.com/chojs23/ec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b91f60eb52d9bfcf1733d3d3c2dc34f969e2d1f2a2af5028fb859425c6cea01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b91f60eb52d9bfcf1733d3d3c2dc34f969e2d1f2a2af5028fb859425c6cea01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b91f60eb52d9bfcf1733d3d3c2dc34f969e2d1f2a2af5028fb859425c6cea01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4536083c38a496ca69376f8e99f22fe79bd77050462a7967218d07f9f8d36e33"
    sha256 cellar: :any,                 x86_64_linux:  "a877e373ba2b11616d3f55f4e46c4008c8da7721bd79717b670e871d5c1799e8"
  end

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
