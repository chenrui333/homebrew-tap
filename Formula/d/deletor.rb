class Deletor < Formula
  desc "TUI and CLI to manage and delete files efficiently"
  homepage "https://github.com/pashkov256/deletor"
  url "https://github.com/pashkov256/deletor/archive/refs/tags/2.0.0.tar.gz"
  sha256 "6bd2c548fc85f0e7896bf2324ffd4b31248a6d78a2ae6d7405f3e229c4fb5f81"
  license "MIT"
  head "https://github.com/pashkov256/deletor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2c4d4a5844926eecae36d15b631d9792bda16c25cb819da775fc44f7bd5ec41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2c4d4a5844926eecae36d15b631d9792bda16c25cb819da775fc44f7bd5ec41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2c4d4a5844926eecae36d15b631d9792bda16c25cb819da775fc44f7bd5ec41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5985ddf10702ea04536b08cc3000d1280a6ee27d2a3023e1fb2519fde4c8a70"
    sha256 cellar: :any,                 x86_64_linux:  "568d933ebf7db599696edb73463502e818dc8e862da1e750cf620859083b6aa4"
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
