class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "f20983e5e24dc4a10e9eef5701086b1d39c4bd20319c563078a4bdcc6f0913e6"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be3378c62d9a7e35b92ccea7ac31e02f0ec5cc189d76667e618414eeb946f2ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "700ee16a7a743475d1ff0a6546aa5d41ca2ead1e6790b0f7d3d27552d46e10cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d6750161550859e3ef2e698c7f25f97b3024e884212aa71363401bc78da2c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b5d73d391d3e4b3931185d44e8b618c28e4bdf82b5d4daa991542b478e112e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bea6fda1178ecaad74261a905fe469f422d493e860db64bb6dace308a13f32ce"
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
