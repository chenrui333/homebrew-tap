class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "00cb1080c1c27c91ca23420240065c38ff4de25fe655a972e1ec268a772f9d45"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d7a571400a080f1661b535fa0575f2a495bb4478cf4f5248e75e17bfb3671e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c58c5c64622af27bb576ac8cd9a29b9e6bf6b89ee457800f90c6020df4d6d35e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "341adda5b76e765431f777ddf5542430f5189b3f7c3ba5a1b4d7fffe4619de54"
    sha256 cellar: :any,                 arm64_linux:   "aa9e363aa8787d11fb0f297de87cba613ce39798b8f49a9b2565f596af958d41"
    sha256 cellar: :any,                 x86_64_linux:  "c1c1a2b5e6976c7392da756255bf834e6218b514f412dd00876dbdb352185c31"
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
