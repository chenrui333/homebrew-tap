class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "fbe4cc7097b0374ee73fa1fa32f229a8a8ba48e6b9792661857e9499a1e20e1d"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "069cba6716f7e5c555992aa4229b72cbc35df6bee9605d15237c7c28db106ece"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e76fef3de4f4fcb7e18b5622876ea878849db9c5cfb1162332bb5b9c3a31947"
    sha256 cellar: :any,                 arm64_linux:   "503a5983b4f6535865de895b2942ca7e059fb834df679c3c13f268cf9c523f74"
    sha256 cellar: :any,                 x86_64_linux:  "e0d5758fed6b589363cd901280b46f4f9550f345c8c3f1eb378aacec05c50edc"
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
