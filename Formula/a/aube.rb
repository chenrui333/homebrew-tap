class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "21d3bc80bdd2a7f6dd91edfcf3a338f5becc8c305d76ed07b23908aaea242dc3"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70c393996c063a77103d9f1fc157309045dc347e0c655fb7b0ceebf6a6c40f00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fa2a8d5065003fb5d7e5a8401005b84bb2459a9e12eb4e28ef2a584609d028d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2dab6a8880782315a2039d4405965e11b16fd13f22300a148bdd4a4ddf7a417"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7d710390b3c1f625364dc4bd53f8ac7523c1613906475e47d6fa26cbd36e578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60a4bdd23a69740781742222ab9f7f1d3b3cc5ea111e4121c074d15f24aad38b"
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
    assert_match "Usage", shell_output("#{bin}/aubr --help")
    assert_match "Usage", shell_output("#{bin}/aubx --help")

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
