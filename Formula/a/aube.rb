class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "75c2d4be53240962fdbfc80b3274f1c9a2281e4bf3ff7014029a6b87c67719d9"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a5612223c94a4be65b28b0112bacc3ca6901efd97d4b8c68be57a0d3b6053f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c0517fa9b91466458c8a842e8ccf7459aa301ca340b70fe1620b3790cfd39ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb3e1816e77eff654d865390b2e51c97a4b847ce2c7195b11b6dcbd29b699223"
    sha256 cellar: :any,                 arm64_linux:   "547b61577bfbafba0b393d82cba7bcb13a6bf85848f9e90e4cad2f3f4eeb1e4f"
    sha256 cellar: :any,                 x86_64_linux:  "24253116b8c8cd6cafcff0b009f322a46e5c249df7231d5cb7c176845dcbabe0"
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
