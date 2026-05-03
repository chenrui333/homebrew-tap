class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "27ce0fa92fc59922cd5a92d6086c8d312e2de0afad35a3f02d0594cd88250e71"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "477a4a67f01e8cbc1987936769837040e3de5a311a731c442a7930bce0f77fdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4f8698fc8858f1dfdbf227173cdb0ab3accd32dd0577f73a96b5578a9af334a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda38c85c2a4936051a09c17508e22c341568e3be6b4dd18895e0ce2e9a1cefe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c16420ac4d9b0cec49af17a31c08a7dad12d0ebbe28ae3db36c304625d3d62a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3561d57eb4cb9e510cdc799722f1a7c14e85f72b2d8e952e91ec5ab18e88f1b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")

    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aube --version")
    assert_match "Usage", shell_output("#{bin}/aubr --help")
    assert_match "Usage", shell_output("#{bin}/aubx --help")

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
