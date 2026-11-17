class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "72c07145c40fe69f40d7758644b50788a09426ae524c43a5aef3b16ead3b4bc8"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3a1ca25113764013394af974e856e54e8226b27ff89ae548270a42538367703"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b794ace8a0306c56ce8c00fb6a20a8f7d0a2bb090eb73cd8da95d20b9b7d7532"
    sha256 cellar: :any,                 arm64_linux:   "78b511f31ca99f941be2d1226ead97b1127de7d34538c0f9545f6b763513aaa4"
    sha256 cellar: :any,                 x86_64_linux:  "7ff89afff9ae2903e8f12d0939c9f2adbcc8605e16fc1084b622a1c79575f887"
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
