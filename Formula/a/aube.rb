class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3b67631408385548cccbe864a7474e001e24afccecf722c2bd7d77fc7bc49d7d"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d68597bcf95770bf5c58a537c5bae2d5834c3aa58cac3a71c529a43a843f3ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b92843d9de19a71af62178510d5d0d8a590204de9c10ee8c10684a717e0f7026"
    sha256 cellar: :any,                 arm64_linux:   "ecbd7e4ce93eacc9067eb34e9622aa4843e633b5e66d2015c313c35bd9881c5e"
    sha256 cellar: :any,                 x86_64_linux:  "f141d5a83ed7c137f0865998c09cb36a7c800aff9f851063f6e9c07fb9ad50a7"
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
