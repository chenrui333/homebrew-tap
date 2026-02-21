class Nosy < Formula
  desc "CLI to summarize various types of content"
  homepage "https://github.com/ynqa/nosy"
  url "https://github.com/ynqa/nosy/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5f830d6398868540a0168aa3f0fbf38c2b85657f3d2af27ccaa51128b817f646"
  license "MIT"
  head "https://github.com/ynqa/nosy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "851f4d879134f7b328afbe7f246f30a3119d714200b7c6700442bac9758790d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d8bd6955c05c589775b3ba5c45174ad24f8c07c9afa983b1aa2774c176dd0c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f77157387a27761c5d222238c7271353501d9796237276bd00afd886a10e467f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caac0e6a9c676091ba43acaadfb871d88bcce2ecf6b9a9f9136e2ef52eac8ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3f33e836c3cd66563399055246de99046fb5cbfcf034af0dcfeedfcb50c721"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib if OS.linux?

    system "cargo", "install", *std_cargo_args(path: ".")
    generate_completions_from_executable(bin/"nosy", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nosy --version")
    assert_match "nosy", shell_output("#{bin}/nosy completion bash")
  end
end
