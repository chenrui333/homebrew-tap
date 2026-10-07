class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "fbe4cc7097b0374ee73fa1fa32f229a8a8ba48e6b9792661857e9499a1e20e1d"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80591690ee830f47e41de2be0e5e7aa80f1c2560e1e414e1b6c967f112542969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaa5658c88c97729177082caf672242fd86b0ae145e0e873669a3ef3d3524b44"
    sha256 cellar: :any,                 arm64_linux:   "e18cea884a657780c410eef0f3588e4ed0c7030879a2671a67f8b326a1ff46e3"
    sha256 cellar: :any,                 x86_64_linux:  "39728d91497b95fee9f0b2be6be760776d14b4d9dab30096397d62f17419b55e"
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
