class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "310e4d6213efc9b1b513348a16720ee9b65fa99ce9601b3d4756e3ef4a4ca875"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a71e3ac912c93d90dc9fac74685303ccbc3e9426e42d7fe8194db785c64ed4e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "384a285bba331b8905fc7cc968165320f591e0e9cf0d0782b27acb82797ad0f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f17edceaece694248c4f82f819c661d7998e02944894a281d14182287a080f7"
    sha256 cellar: :any,                 arm64_linux:   "7d6500e3e2dee71288665a348d6835be6c7d1b98035396528b119a36342c65fa"
    sha256 cellar: :any,                 x86_64_linux:  "2db60a66a28e4a42275008ac2321e5af50febbf0ed4090fc10fb12557fcec3be"
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
