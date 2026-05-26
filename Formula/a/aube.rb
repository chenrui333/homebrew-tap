class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "872021d45cd8404b3d5f3fb5fa4e14af4bd699a58d91f9ae40164ea3d430f182"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "025ae76870dec6e8031743e77ea1a1b37cfeaa9765a3e92826415061611cb871"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e9c3c98392f03999a3d9f230dd661917cedc83d2b365dfd7fe3532419c260cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa3efbb33e6a4ad2b62b9e35eda7c07576cbcc11c37bf826059c8c236d3405f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b42934fd7fd41a168ea855baeab6d9d3eafdbfa6ee304ba6383add5585c32b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b6b4e4657b8979dfd59474f11534c41b6ad9dc298d7729a123ca57e99f05df6"
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
    assert_match "Usage", shell_output("#{bin}/aubr --help")
    assert_match "Usage", shell_output("#{bin}/aubx --help")

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
