class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "114154f539e6e24e2d08102d9e37885b57d66130f3bc3085b1d095539ad4ea83"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8f22826e2d88981f6af72e9ab735e6ecbd89b9a3dddd5990f1a7c23b1d8ff60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c14b47e79f9ee272de735beecab4217310ae5fdfdf26092c9603ba6daebe0339"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "570ebd63ff1d8c486f29bb031218f721417cb9e1baca7a3cca28546f2dc06855"
    sha256 cellar: :any,                 arm64_linux:   "eba6e4ecff7e0ae0211b7b60a1b98d910ec74e99e7fcdffe1c2959feef50ae87"
    sha256 cellar: :any,                 x86_64_linux:  "0c5aebe8d78a83a30bb0e8c8ac7372265bea42316340b653169d48877785557e"
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
