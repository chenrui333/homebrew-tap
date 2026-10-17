class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "8725315dd5f702fab4b2bf68bbb4c5fd25d1974ef33a6734392d6d751a8e3ee9"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62d3d13e8672eca659783f22f08748187783872be55016844f3ac29bdcce486a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18bf8d3b734432944f2ce90f8769c51cd506c1c48f1854808a8b006a17fb9ad0"
    sha256 cellar: :any,                 arm64_linux:   "22b19b965b5cf28014e8115f11e40b44b489552710ce3be9238786a830c0d994"
    sha256 cellar: :any,                 x86_64_linux:  "ffd1dd1d3b3d04cf37a4362c350711e7bc6fe94bd5a1c227bd79e5f6e7269957"
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
