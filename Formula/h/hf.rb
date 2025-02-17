# framework: clap
class Hf < Formula
  desc "Cross-platform hidden file library and utility"
  homepage "https://sorairolake.github.io/hf/book/index.html"
  url "https://github.com/sorairolake/hf/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "0cc5b846860e5bd9692f8e6d1a8f21b203f6fe94d87ae250ad3f6e323abf1ca2"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f35304cb38f6f4c02d5d5e87dfae71952b9297c52a50cb291994f775cd0229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "319241888b385e664172739b350fd8a315370e244e6b9d0276d1f41d5be55b41"
    sha256 cellar: :any_skip_relocation, ventura:       "f3ac55b8a504ce03b9a4e11498b5e6ca5949c1fab25312d74e11ea04bd6a17e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "163880955531ee34f9dc12a249dd41e5ce59dfe31d60f8f1eb5a8e1ff63bbd7f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hf", "--generate-completion")
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
