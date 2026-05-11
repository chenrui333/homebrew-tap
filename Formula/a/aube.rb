class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "89ce399af7d9cc8da829e48ab5f824d2ccc6343fa10825b7fc0de90a238976d5"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16e545e028e932dfbf2fd3140342086c834efa2910085d6dae1a3ef3be73ee2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8215ec3d899eb4c08a9a41cf78ab2eaf1a93a594e2d58ee0d8e98681d6a75d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bef6a24fc68793b454aab1920b43908f974d5ad7ee65ef93adcf6bae3dcc2ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "033e46e495fa4a53cb7dfcd95d9557c8e31e601ce2f9f37a5d506a5a5942e6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b1f4a1857c9690edaac75202011f3b6c1a270559c1db098a826beeaa481ac6"
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
