class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "b51611ca269dba88d75056e97bfb9673e3c1c3ac822216aa56eeff49f299487d"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "623ea91c38ac7894b39d29123a04a9156a44869376ee8f796e9ce623b692a45b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030edbfac121b122ae6c9eb7112c5a32cf8fb212eb3415cf6498d3bf6d287ea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d0c84ee7597dd154b4aea5d719c0d3d437b922d625a7cfd58e9009e7095f753"
    sha256 cellar: :any,                 arm64_linux:   "5b8c947c35aa4a81df0e661e45d0846f02f8fe08758e7f17041eb9bdb4808bec"
    sha256 cellar: :any,                 x86_64_linux:  "9d12c1145f433ee706801067ef28d2dbded7d7636697f9dc965e6a68becc362c"
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
