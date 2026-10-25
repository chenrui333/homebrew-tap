class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "fe8a03efa3c72a9d96d49cbe6bc17b7e858074277f541c93562af55d1af5ed75"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3205b4761b2c54aa948e4413f504ba8b0b8f35f6d7194a97c97696a6aa86a09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3580a0e1a18ce9db30bf68567b486a18914f7644d76aca33e64ab53bd09ad131"
    sha256 cellar: :any,                 arm64_linux:   "24a6437c01476efc34a8634ccf318b1b250cdb67d4282066359eb9a19afbc1cf"
    sha256 cellar: :any,                 x86_64_linux:  "3dc4caf31fce01a2029577f548821c5e16e5f02ccafdf4520d84a0dd4e788ddc"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
