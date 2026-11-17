class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "72c07145c40fe69f40d7758644b50788a09426ae524c43a5aef3b16ead3b4bc8"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2109d8b18d66129369e17f7e756c97834b2960300a86f2cf4e5e8e15e0aaad7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13a5bdfb0d9bdc94fe1ea5da8092f1fd0699b71b8828851f0867407a4da7a071"
    sha256 cellar: :any,                 arm64_linux:   "3e697ddce3af3ea42bdedd0b2df6d563132d0fd3f95f3588dc1363824c46cf8e"
    sha256 cellar: :any,                 x86_64_linux:  "14e22a81a8618840ce508846ebf4374b0ab4c767a4c543dfcc126b0f6e37a6db"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
