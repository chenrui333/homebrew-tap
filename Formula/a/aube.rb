class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "a5db45fd56ff937afec0b0c503eac4d822c39016cf1e004fba684c50709ee2cf"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f265f2f2727b6d35b3e6055f8b8166e0c7b51ceba5ae38a65f07ae0d91ac00fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48901fb68c733b04d7b7b3a1093dcc4c4b5782fd1852c610ae382f10a1ad30ce"
    sha256 cellar: :any,                 arm64_linux:   "f3d127d22ad03dd652b91da466725dd463027e04ea1770f211f122bb72e8e88f"
    sha256 cellar: :any,                 x86_64_linux:  "54211f771a86fd2e7b32bb3829e4c511d1b4291a3b2eecc05b38f0855ecd7af7"
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
