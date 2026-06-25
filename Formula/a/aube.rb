class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "52bd926e6934e4b4da7920b6b85fadee1767872a6bfab1b793994208217b3b3d"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eddcb541a604a671d6659ce2ee912323fe38d34a0815d77bca49d0ee218b0da7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d4cdf14aed35abf92cb8b924fd9f202d714e0a5fb8e0c055f98ed817747b31e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7e96d4362d3f8bdbd182122ba805d81facaba688dfd9320159fa63e7a07777c"
    sha256 cellar: :any,                 arm64_linux:   "2de44d28c991cbe8a4df3e2d14c0ae25e19e2b5070d738cbaba41a2869c90d8a"
    sha256 cellar: :any,                 x86_64_linux:  "1e34fe30146b17b1389b4d2fd87e75184b3f4c292a6aa18ca358c734bf19b203"
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
