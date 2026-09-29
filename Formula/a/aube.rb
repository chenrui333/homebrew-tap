class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "61e8a9be3c252122e77de825b7799a56109044da59143a3251bda8aa4241d1dc"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59c9eabb9f15215cb23702fec35e915238e67c198806f537aff5d069c0f32306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ca49d5caa5d319f322ab48258c2e011e77f40277006617144d025570b181a80"
    sha256 cellar: :any,                 arm64_linux:   "e12d710d67a034b0415f62e6aa59fc876de9e1a7644ec0b838da95fd97c1cf72"
    sha256 cellar: :any,                 x86_64_linux:  "8c821daf3671cc9dd96a691f992442f783c0c16888f3c1d8ef9e01575a49072d"
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
