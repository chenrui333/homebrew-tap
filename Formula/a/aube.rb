class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "b55b6bce1acdab8e2b42add8d5dfc0789e3b6adbb2c7b190470c663c23515da8"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdd9ef96681747cd5514def2e093ffbcd88339305cd4501a05e937380a84f764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "421a26630c60cc5d0b587d86dcdcaadf53266bd04cfe5edcdefd613f6d8ff8dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f5f6654685a705c2fdfac47a51b60d8749dd09ef509c27549aeb53e0e58d306"
    sha256 cellar: :any,                 arm64_linux:   "e8182c98bec266f82bbdab920ecddcaeee119c8a59e6ef7b1d8186c127b3e7e2"
    sha256 cellar: :any,                 x86_64_linux:  "b5ad60323344d6614a9e504b3d338579e4c80655ffc7186b4c17720e384aeeed"
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
    assert_path_exists bin/"aubr"
    assert_path_exists bin/"aubx"

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
