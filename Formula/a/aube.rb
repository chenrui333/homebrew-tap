class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "db77d64748fa834c76a67a846b7dec0f4fdfc48cd3a1d2274b3ba92079d030bf"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0985dfdd65ae8fa38d822eef7e427f256428eeabe93b25523a979d0993e9642d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2b7f1d9ba8cb08b7e100528985fce0ba1fbfc555a4860fcccb9af53b5446840"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "974ee6bf0c2a9c32fa0c78a8fbb4a9a94a491cf12049f0d40f09143bf83324e0"
    sha256 cellar: :any,                 arm64_linux:   "79831adc94592ccec7d1320ca68914c1c40d6788ea20e242c431b32caf0ebf8f"
    sha256 cellar: :any,                 x86_64_linux:  "cc7eaa90d189bdb472ab84e71be10d63df07b3c6ba40e6f12fd8ab7b4f508fdb"
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
