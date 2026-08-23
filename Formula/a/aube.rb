class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "00cb1080c1c27c91ca23420240065c38ff4de25fe655a972e1ec268a772f9d45"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2134a8b28cfecaf2a6019ecc5c6737f6590cd924d4572d41093f3597c442c877"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50920c2ac99f6691be75c6be7d5a105a2809579b67102361290f57c000fec138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "270bcd6d32b79a6d8a743e12e8a19239416edda5a1a4caf811f47c1bae52f852"
    sha256 cellar: :any,                 arm64_linux:   "5e095faae63201760454523788bc63347abdf8e84a3d272ea4d92f53643c10e3"
    sha256 cellar: :any,                 x86_64_linux:  "4faddafd3e7655dafcc41fc9f32da554562fcedd7f21e1cc458382318a298399"
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
