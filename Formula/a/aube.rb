class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "a836796d9e72ac8af6ad31172572a2f7919cb2481cd318a65e5e3e1052b5c429"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecc9efbce269b9f95eef345937a11cde45c28953e7c5d85781398e7521acd8cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4204f21f4c2f27664c61620472a0f1acbc5446dfb499cf1138c42098a5d3896b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aabfb33a7b36349f93040df5c62cd90c518a876a79e84f00790d264066c22839"
    sha256 cellar: :any,                 arm64_linux:   "2a4c3bdc8ae0a8418f173cd6b84a3703f85da7a49bc18c1652049d4edab217a8"
    sha256 cellar: :any,                 x86_64_linux:  "47966d9efa0cefa4735892a8d4a4ffac9aaea237fa95bf0bd7107fa62979dcce"
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
