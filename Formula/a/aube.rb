class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "7e11c554fccc1f3d82fbb3a560206d51b058e8f5c8fc31b8f14eed3750f8e80d"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f8798536f2743b2c49b6586a5cb36f0636a3dbee232a9b91473ddd02ddee03e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b60222e4d36608510e604e26880850bb6d5315bfaccddcce07f17aea3d5479f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4b9030c91207d51d938f645460c7afd5a2f2a3201d5337a52dd9341d4d9434e"
    sha256 cellar: :any,                 arm64_linux:   "9f065fbda10ab922861d3ae20ec696a471112fc2afef22782d669b2d102e0138"
    sha256 cellar: :any,                 x86_64_linux:  "647f882b75dd4b04ac98260fa9e0d218d177401a2f92fbc5d8194a0b8b93d28a"
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
