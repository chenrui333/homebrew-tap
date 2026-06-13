class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "41db7450c0df1b37d9d10fe9816689bccb004c14c8c503d1279f6cff59bd81b5"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39124a665430951d357a78a9440fadb7eed9441429c57d97bbdf383ca8dad801"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83988ff4e0d5f311a70c4a7c53a82504bfe14921bc1ace6afa879f2453a8d13f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71851714422014eb81c9bc3c504a9d79ce8cf746c72627f8c27a52e4ffafbf8d"
    sha256 cellar: :any,                 arm64_linux:   "359cd3d36090b8310e7f6ae533e7c2737cb967564a7e8783ae73fe4ab967d06b"
    sha256 cellar: :any,                 x86_64_linux:  "672cf09aaac1b52d150671d55acaad1ce14c5df6e6fa394c4ae45ade9c07881d"
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
