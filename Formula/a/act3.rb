class Act3 < Formula
  desc "Glance at the last 3 runs of your Github Actions"
  homepage "https://tools.dhruvs.space/act3/"
  url "https://github.com/dhth/act3/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "5ba04d59ba44e659a0a23eee674923acd92c4bfd622e12bcf8bd993468699fe9"
  license "MIT"
  revision 1
  head "https://github.com/dhth/act3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f71114f63517c0cca80eb7e4e1a166ea08bc759c5b3a6f1a9b74de9ab0ee27d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f71114f63517c0cca80eb7e4e1a166ea08bc759c5b3a6f1a9b74de9ab0ee27d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f71114f63517c0cca80eb7e4e1a166ea08bc759c5b3a6f1a9b74de9ab0ee27d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52e404874ad970715a52d7b9b7424600ec94f086bb79f60b9cbf724171b99836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "149ea9a59d6a3f9e636e187c1afda6c5fd3b7f67c740d0ef6ea39dd299756e34"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "invalid"

    output = shell_output("#{bin}/act3 config gen 2>&1", 1)
    assert_match "Error: no remotes found", output
  end
end
