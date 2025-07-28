# framework: clap
class Hf < Formula
  desc "Cross-platform hidden file library and utility"
  homepage "https://sorairolake.github.io/hf/book/index.html"
  url "https://github.com/sorairolake/hf/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "3b2920e53ed5628b5ab44ab1400835a3ead1c0b7fe73722b1512a3ca4e41c6d9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b77f3b82c0c6a9f1c6a2c9c15fc0d73f060c00526632cce257cfc7491d703ff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfdfcec25a5f2c02092a3e97013ade4285d370a7cfc9652ba45e7af8d24fec67"
    sha256 cellar: :any_skip_relocation, ventura:       "d2b337e0752471e04c2625a5a0822deabb685f50265fc1c5f6e5cd67e5b8a83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09d4869995eb40dbf597d6cacf3ebc164490edc6cfbac381e38665c00c4b6d58"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hf --version")

    (testpath/"testfile.txt").write "test"

    output = shell_output("#{bin}/hf hide -f testfile.txt")
    assert_match "[INFO] testfile.txt has been hidden", output
    assert_path_exists testpath/".testfile.txt"

    output = shell_output("#{bin}/hf show -f .testfile.txt")
    assert_match "[INFO] .testfile.txt has been shown", output
    assert_path_exists testpath/"testfile.txt"
  end
end
