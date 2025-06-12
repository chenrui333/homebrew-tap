# framework: clap
class Hf < Formula
  desc "Cross-platform hidden file library and utility"
  homepage "https://sorairolake.github.io/hf/book/index.html"
  url "https://github.com/sorairolake/hf/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "30b4475571c3191f8b7cc229da5d21490ae5fee4d67455818d8f7eee779d1a1a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b4165d327359c88e423af0f3f6e8eff8dbf23028b8520529d0649add8ec5de7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec7b187069381cf0601bd2ddd801d29cbb474a81848000661f5b846ee1c86bcb"
    sha256 cellar: :any_skip_relocation, ventura:       "50d572a5692365ca306b37b84e40408f2439939dd61808e3647b3c97eec95a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fca819e3ce74e6b9c55f814e41c0313e3cbb85cbd6af71f06a9d09c076c16474"
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
