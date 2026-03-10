class Ec < Formula
  desc "Terminal-native 3-way Git conflict resolver"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "43b810c771d9d71d66fb252620ec1a8d255b4738493b767b2329a248cf39b4c7"
  license "MIT"
  head "https://github.com/chojs23/ec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b17cfcc40f81568ba951026be68dfe1d2d7b389ff123d709aec21a3d7cc6a01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b17cfcc40f81568ba951026be68dfe1d2d7b389ff123d709aec21a3d7cc6a01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b17cfcc40f81568ba951026be68dfe1d2d7b389ff123d709aec21a3d7cc6a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05e8acee84b0b502f0d54c9f6ae49327d8a34f03dd7684849fb48f75877a54c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "860fa6e8a064c67523688a62235b6f0e2c231cf8bf5f062cd6a283393a0e33d1"
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
