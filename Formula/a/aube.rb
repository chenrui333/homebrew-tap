class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.8.5.tar.gz"
  sha256 "07033565137d75bf7aaced18761e00bab58a0d146a4db1b5f80ebeb4aedf82de"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15947fe7ce5ac5bf49aa83d345c383621736e2c7fa3952a8c0bc2177b05d0f59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b53c95e63eba634841d5a0d9a48c876382aa0e0756a3c4cd7387ef7f1f503b5c"
    sha256 cellar: :any,                 arm64_linux:   "30ed6d17825a4e9821833b490c4052867a978a12346a359b982f0bf1eb96c388"
    sha256 cellar: :any,                 x86_64_linux:  "4e386e11711ba8e2578176ddf79e0d5657832091c063cc5fa298c38ff1fb0b7f"
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
