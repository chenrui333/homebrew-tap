class Codespelunker < Formula
  desc "Command-line codespelunker or code search"
  homepage "https://github.com/boyter/cs"
  url "https://github.com/boyter/cs/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "1fb48991eea45067386309abc08dad91e4ff8077178130162902953f88100a34"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boyter/cs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3e88dacd07849e7f0dd9e3fd86763c21e8fdf8e150d7989adf53c199e32a02c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3e88dacd07849e7f0dd9e3fd86763c21e8fdf8e150d7989adf53c199e32a02c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e88dacd07849e7f0dd9e3fd86763c21e8fdf8e150d7989adf53c199e32a02c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3ca2a4d1cd369f1c0731024a10624bd320403086f9d2a388bcbf191c86f08ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "117d68bd97296e1bdb849d43c9fd49eca73046c655f792e23177dc6d40e02598"
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
