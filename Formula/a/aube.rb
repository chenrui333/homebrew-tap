class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "497b0f1abb8dc82d2a47ce187d0e089f747b660521137059cb3f969f0f1eeb88"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d79c35534c25eaa8c6ea8b917de570391246be73364c76cc81e9fc15045283da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9acb2c8065d680faeb1b700ec5abc63b935a7fb3720337a751ad6c9bd09093be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1fad550ad90205de6ce8aadced1b53671068f669ec26465c7199bc4c57b8898"
    sha256 cellar: :any,                 arm64_linux:   "f8d54cf68b9f8f817399ebec0a77c8d0b638a548d3dd99f0e6e8f86809bccefe"
    sha256 cellar: :any,                 x86_64_linux:  "d070e1c949d904b05544bcae43d18fc340cfa2bd26b4f3f84c66c0c2ad01f2c2"
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
