class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.2.9.tar.gz"
  sha256 "bb33990b2a11b718303185abc3665c3d1c6ad65c91bab0a91db37ecdecd9ad7f"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a6e05e1ad9b2f6de0fe0caace9582381a9d7c981d7ce901bf811a875bde0e29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04fc93ba793f4c4d7d18d85882d7625781ae56845226f4a78633166397a3dd34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c6a80b86293be5b8ed4c61aad67f5fff8d8b20c66eef4849284893d4cba581"
    sha256 cellar: :any,                 arm64_linux:   "642b55c724b9e5ad96090dc1d3147c3f65b689ff3fa489e0b14f47f494e5f254"
    sha256 cellar: :any,                 x86_64_linux:  "9a4db1749f4619005bcad6a44356026a37d1ff650ab18648442a917c77c85e30"
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
