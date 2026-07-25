class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "75c2d4be53240962fdbfc80b3274f1c9a2281e4bf3ff7014029a6b87c67719d9"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fca600383fada49a6e415dc558ff8ade2cb03a6d3d0eda9ba06e6a56af0dc3a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e8c9eae5bf70956dffe66fd3cdec549a0e7669d2c2ca5db8feff0e7a1641d54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc8986b4c855d7fd497688a99161435330ab153ab9bbfe6502037c7df944facc"
    sha256 cellar: :any,                 arm64_linux:   "0b5931cdc7b87179a275913370bde0c9109becac4c096253521ee7fbe5633b57"
    sha256 cellar: :any,                 x86_64_linux:  "e8d5d7a917c416f8b77b1ef001e20a1a64c9f568c06a037d012e0fcefe736492"
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
