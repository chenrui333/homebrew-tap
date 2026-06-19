class Deletor < Formula
  desc "TUI and CLI to manage and delete files efficiently"
  homepage "https://github.com/pashkov256/deletor"
  url "https://github.com/pashkov256/deletor/archive/refs/tags/2.0.0.tar.gz"
  sha256 "6bd2c548fc85f0e7896bf2324ffd4b31248a6d78a2ae6d7405f3e229c4fb5f81"
  license "MIT"
  head "https://github.com/pashkov256/deletor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baf00de08044f1219e2b35271fa7a12f01b7bfd04212d4c98464e6fc221accf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf00de08044f1219e2b35271fa7a12f01b7bfd04212d4c98464e6fc221accf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf00de08044f1219e2b35271fa7a12f01b7bfd04212d4c98464e6fc221accf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1ba77682d7a8454fd756f5dbd178640ea7398603f551143061963bb94b78439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae74714595ac50e3537f0bb9e030708f6a07265dbd83f8150fe4428d569453df"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_file = testpath/"testfile.txt"
    test_file.write("This is a test file.")
    output = shell_output("#{bin}/deletor -cli -d #{testpath} -e txt -skip-confirm")
    assert_match "20 B  #{test_file}\n\n✓  Deleted: 20 B", output
  end
end
