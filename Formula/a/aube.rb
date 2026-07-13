class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "114154f539e6e24e2d08102d9e37885b57d66130f3bc3085b1d095539ad4ea83"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9da4abf7e307c6083f9146520956f430fe7dbe4c3f143a404fd4227faf5dc18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75cb1fe6141d8d14a580f9879d82e9247c34262edeccb2272630ff6acc7de994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2572c9e094a3a7b20723fff8e9bb433ed0a0fa2ccc52a11ece841c79a4b4c71c"
    sha256 cellar: :any,                 arm64_linux:   "ba0bc1020f8c615911fc3d8ba4b3605f3b97f67b040ea7e36bc63cc6fa86be0a"
    sha256 cellar: :any,                 x86_64_linux:  "f9772b7a9ba4577ec5a61a994496e152e23e49413df1fff6e9a037c74f0c652c"
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
