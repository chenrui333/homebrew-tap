class Codespelunker < Formula
  desc "Command-line codespelunker or code search"
  homepage "https://github.com/boyter/cs"
  url "https://github.com/boyter/cs/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "6553dfbfeff046d6363fbea8a46fe9ed0f145e58cca89360b84cc86f8e7cad7a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boyter/cs.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codespelunker --version")

    test_file = testpath/"test.txt"
    test_file.write <<~EOS
      This is a test file
      to test the code spelunker
      functionality.
    EOS

    output = shell_output("#{bin}/codespelunker --dir #{testpath} -f vimgrep test")
    assert_match "#{test_file}:1:0", output
  end
end
