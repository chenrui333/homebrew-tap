class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "b80d5f093cddcf4bd9c295686ae6c1faa2fde838cafc061aa1b347c84dde3323"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "46ae7fe7fa0c7f2944b93e0e7f1530b5b32f804b54a5c8106082c072990e78ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc03aca3e3bbac81979e5a903c0dd38243fb1e9bde5058fcf67381425c5a8990"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a76582ec70a409ce9e4fb2698a4bd74c3a04ea6d4e6fe9038451461b9779232"
    sha256 cellar: :any,                 arm64_linux:   "387b042dbbf5c91e10b1a36d10216afe24efa837fb354e3a7d64cd41864e05ff"
    sha256 cellar: :any,                 x86_64_linux:  "d6e226a776f7e1917027ac8b2fa9e2c68c9807eca145e3112225c4882eddc386"
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
