class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "6efc7d07dbb58ce01a7f91117a76461c718b1248bc60ec87f5a37ecec7214cf2"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87c5af7637ee75c9b951efb80cb3346eb38581aee4b50ca1447f6f64cb805613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62ee6af32cb8548f53c63cf4254b8ddd51f39f30fdf492c34b4b76dd79cbdee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa1a2d17a516910a0acdbca86ffe24b33292b044c137af7d6189c20e5247a3ba"
    sha256 cellar: :any,                 arm64_linux:   "2cb1951556e0d2214bf1b3c8542e00e1ab525630450eb87e02e8b5d8eb82a01e"
    sha256 cellar: :any,                 x86_64_linux:  "c9a44a6294c332fae0bb526982cb881f3745f7b0a9d6a14dd8166d24b1687f23"
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
