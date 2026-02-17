class Codespelunker < Formula
  desc "Command-line codespelunker or code search"
  homepage "https://github.com/boyter/cs"
  url "https://github.com/boyter/cs/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "8bf45d8ad5b379cc942e4e54cbede2b3441d71dfdeb5487eeb5aa0597779d9c0"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boyter/cs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c15e6a3d6e5f7c07f3eefba5af82f1f9a9867d6499b3b0898030dacb30bb954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c15e6a3d6e5f7c07f3eefba5af82f1f9a9867d6499b3b0898030dacb30bb954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c15e6a3d6e5f7c07f3eefba5af82f1f9a9867d6499b3b0898030dacb30bb954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bd6d4162ae29a5998404b0afdd0bd7fd14fc83016f056ef10b4aae32806d7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8907056c5776ace3d9c9d1f51bf1eabdffc4013e3354b45738270f76064a68d0"
  end

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
