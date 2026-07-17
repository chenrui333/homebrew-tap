class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "310e4d6213efc9b1b513348a16720ee9b65fa99ce9601b3d4756e3ef4a4ca875"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f7b3e3bfdd2e3fc26af4ac9bbfef182ec093ba1784cc6b6c20bdddc4661c5ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ee2478855cbdde40d6d067e99ae853907d346dc6f42d6ea288c1451886318d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "663411e63ad5f49f449b0a551e172b1ed20a835d015bf987e4c9cfd6296d33a0"
    sha256 cellar: :any,                 arm64_linux:   "b2dad4794baaa87190f3de93b7a2c2a13c5fd214223e7e8a046bcb72cb16fb33"
    sha256 cellar: :any,                 x86_64_linux:  "b310ad801fdecee6f4c6824b53e8b8847a552a505a4e5e3c7518923d81680fd7"
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
