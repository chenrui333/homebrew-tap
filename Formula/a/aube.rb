class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "94cf5dec7e275376fed870324ea1e6b12f21280964a3595dde06d248e778cd37"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b44c2d3bdfadf42aacf5c18f9f031d86e6cb3c8538226bc4a7138723141a77a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723f69ea386a52032a8a3d3d8a97b290b2f0e2a71b15b142cccd767acf771e72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9286f45ca22416b28f2c7f535f2039ac9fc2dce1b577cef2b96fbed12eb3ab95"
    sha256 cellar: :any,                 arm64_linux:   "771b0377393b2de1889f6ac04db77f15b1d01e747606ce57e56a681530ce882a"
    sha256 cellar: :any,                 x86_64_linux:  "cca85db192faa55c1fb809ceeccc2ce1552e2f08e51fbe48f4a992a075c0c7e8"
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
