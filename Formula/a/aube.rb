class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "17d1bccfca0d6c7ac5126b11ce685c5359380dc8e522c5d3e943dc1f92ea8fce"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd4b424cde0082c798c4caaf50e63a29f4ac9fcf86a5fdce51d23046ed6857e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb94b4634345701d9318c6fb61f5dbbb4035122e754e22c9c636c74df003a32a"
    sha256 cellar: :any,                 arm64_linux:   "3bec0737aa0c242523a0d255c5b899c4aa04b1897d263de98bac07c57bab35cb"
    sha256 cellar: :any,                 x86_64_linux:  "12d0ac1271d209b6bdf62918d616179d7e7c3e5c8f42c789199e20cd7ea2b9ba"
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
