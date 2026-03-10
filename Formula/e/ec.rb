class Ec < Formula
  desc "Terminal-native 3-way Git conflict resolver"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "43b810c771d9d71d66fb252620ec1a8d255b4738493b767b2329a248cf39b4c7"
  license "MIT"
  head "https://github.com/chojs23/ec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fbe0712ccbd621aa02c93d7dce39ddb45b63bfaa9b8ab4b12cc6c758633f952"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fbe0712ccbd621aa02c93d7dce39ddb45b63bfaa9b8ab4b12cc6c758633f952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fbe0712ccbd621aa02c93d7dce39ddb45b63bfaa9b8ab4b12cc6c758633f952"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fe9d925dd3c47cf3be359e9637f08445b2d0007e683ac69581ff5476094512a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "309faddb1d0c8bd59e9b800f63f5f7e56d37ff0aac307d915dd43e8d88707082"
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
