class Ec < Formula
  desc "Terminal-native 3-way Git conflict resolver"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "71bf8b390b5f5b010c07b65ecd4243535f690282f728cd164f9e2a79d1f14577"
  license "MIT"
  head "https://github.com/chojs23/ec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b134f6bda98642b647797407175957feb39bf26889514a2a299cd06b8fd3df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b134f6bda98642b647797407175957feb39bf26889514a2a299cd06b8fd3df3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b134f6bda98642b647797407175957feb39bf26889514a2a299cd06b8fd3df3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efae58d5d689517f313086a92d8cb84a747c10196b15213c268b9ca430308684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771408244feba2c642d47236336019c5a6da996389f41d31e177964078a6ee5f"
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
