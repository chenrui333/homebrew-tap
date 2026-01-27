# framework: clap
class Hf < Formula
  desc "Cross-platform hidden file library and utility"
  homepage "https://sorairolake.github.io/hf/book/index.html"
  url "https://github.com/sorairolake/hf/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a7bf875dedd673fba5bd69418ca197eeaa7c8772ee57601bbbc01bd9e0d3bad1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b209044e8687c5d49d1c13afd9ec9a9fcea7f4db3916044c4989266a46dbe5b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aff3750f259d5ea8add85dc3f4f01ca1b0c710fec546761f8d3751046d75460"
    sha256 cellar: :any_skip_relocation, ventura:       "52ef18523217590842dfc968cff49774ce78b1885d785c9fa79f54be7d729260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "507bc9fda427ba42088684947a403476ae29673313940c0a107e486faf9d6e69"
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
