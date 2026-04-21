class Ec < Formula
  desc "Terminal-native 3-way Git conflict resolver"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "348d264be5380b909fbe49b145ad882f479c17ef9babbcf753b80c2b8ffb643e"
  license "MIT"
  head "https://github.com/chojs23/ec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436340fb60a4f386d64627225513f651a804da51b9599e4d1c60517f4cceb3ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "436340fb60a4f386d64627225513f651a804da51b9599e4d1c60517f4cceb3ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "436340fb60a4f386d64627225513f651a804da51b9599e4d1c60517f4cceb3ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40f937a86eafd13129e5e21c2f8b8c5c0e94fc6b3fccd54697bb8000981aa191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d06f8a19b989bdd9af4708918c7d88da8c69b75c07c52616171d59dd2f09b7c5"
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
