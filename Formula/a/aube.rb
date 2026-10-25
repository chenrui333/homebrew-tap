class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "fe8a03efa3c72a9d96d49cbe6bc17b7e858074277f541c93562af55d1af5ed75"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "965216b623a4ca7567b10f44dfdfe6f3a52f4b76a5681fc5c8ed9b8ff73548b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1057b6be78176c4f42a685a53b3f675bf8ac7acf81a4bdbf34e0f6f42e036dd3"
    sha256 cellar: :any,                 arm64_linux:   "c73e67f84496b1b238d512d976b69e957899970cbaee8764f4dd2791f7374a7b"
    sha256 cellar: :any,                 x86_64_linux:  "93619df32565c4281f24a6bc9e2932702d305bdf25e0568e9506533931cba77b"
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
