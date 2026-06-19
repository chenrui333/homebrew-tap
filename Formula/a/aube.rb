class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "aef37c9658e427269f3f5c26384b43a83233bcf403c337794fa1ee66d8478cef"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84923ff4505fcb36ec25bb4cb4e3f4e540ce40d5d4ad0eb440272f80c1883c5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "559159c4965a6b7be334b9e85c427bbbaf5b6b478242329d30385cd822d2c09b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ee32f4861928b86d280cf54e244efb892cec07b68d8f3a4ec9d77d046657251"
    sha256 cellar: :any,                 arm64_linux:   "9c0d83e5da02f7b929b243c60138f433f49e1e558fee2cb64a9decbe30b17d92"
    sha256 cellar: :any,                 x86_64_linux:  "b5fb139767c011520ee61652d4a3a9b12c8342db2421dae3d9553bc4744240d5"
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
