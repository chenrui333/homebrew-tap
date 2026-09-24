class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "1c1bcb9e4bb93a8db2e7292c44aef8b90c5454f50d3542dffe33c1e1cba9fc26"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90824e386844ea3c71aa28fcf691f028fbe86534aa002360dadbd9f91da4fade"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acb5b5b749d1008ae59e3c91183e04e481fb2dd2f7089516b4078ea5d3aeebd7"
    sha256 cellar: :any,                 arm64_linux:   "0cbaef24323f2ca07ea112f2486a42842f85a5ee926d99abf82bbbd915c4e62b"
    sha256 cellar: :any,                 x86_64_linux:  "4e2d581f7a6135709075f4e9fa2df0a110bc4a3694bff4608f149cfb61541a1b"
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
