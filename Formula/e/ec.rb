class Ec < Formula
  desc "Terminal-native 3-way Git conflict resolver"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "bfd7017c09b395df73850b72d7b27f026fb6001b2ac165097f7c3d7cebf23534"
  license "MIT"
  head "https://github.com/chojs23/ec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a566f007d28bbe2e5c71afd7936a0536c81f5681844e14fd88d4b33b927b905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a566f007d28bbe2e5c71afd7936a0536c81f5681844e14fd88d4b33b927b905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aca7198340b480f3a0484681d4f243a46fcf659688305fb899e9970be65a6d57"
    sha256 cellar: :any,                 x86_64_linux:  "4bb6a105d65ecff5840ccf27e39c3033d1a78ac7fe9050db88bd91105fce03ef"
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
