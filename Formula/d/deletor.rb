class Deletor < Formula
  desc "TUI and CLI to manage and delete files efficiently"
  homepage "https://github.com/pashkov256/deletor"
  url "https://github.com/pashkov256/deletor/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e4a2a2ca3a1fa420c1962c2d8dd1778a3fbd06dc9a468e6d5f76b9d26971bbeb"
  license "MIT"
  head "https://github.com/pashkov256/deletor.git", branch: "main"

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
