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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa2e9030510ea6ad0f95188ff0f5b99f8dc84fe1a01351b3008e8ea014b6772c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa2e9030510ea6ad0f95188ff0f5b99f8dc84fe1a01351b3008e8ea014b6772c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa2e9030510ea6ad0f95188ff0f5b99f8dc84fe1a01351b3008e8ea014b6772c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce0d6cee5edc3ad75dfcb09ae3db378163b0c866ac41827bfde21b2115f7c6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0dedf4cc5f1f27099ce5efbe9dce785cd139c629677835165760d4ff01c2a95"
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
