class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "b55b6bce1acdab8e2b42add8d5dfc0789e3b6adbb2c7b190470c663c23515da8"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a8285db8be9d9eaf532d407fdd55f7a97a7ccf41462d95c62f117e6085f7a92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25ad2cf1e6681e21fda9ecf67ca3eca7b499e9122f4ce9bef2cf484f24c2a74c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "111b28e1a65a804c77e4b8dfab900ac1628d21fb2abada615a3e1bcb275a6ee9"
    sha256 cellar: :any,                 arm64_linux:   "844af0958c3c273c6ebd9a2006b0e749ebe9aec3827ad45f998ea9c5d3d44248"
    sha256 cellar: :any,                 x86_64_linux:  "049e9a136850a46b65fd30fb060e7dc04028e79ddce1779a2df057ae5ecc1db3"
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
