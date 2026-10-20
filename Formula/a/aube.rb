class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "157d04293f4a84387ac0aa36f4b080d1a47f4e69dae2ed13c058be076a4c467f"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e617a15773143a9d0e65d9000c17fac25d5f25017b8968c9046f0acf6726de11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c82835404b26be13b2171660d817d2b271ba2a323f379b017ae9a77172e1dcb6"
    sha256 cellar: :any,                 arm64_linux:   "be21612b22a2226d2de8db1e04a3534218ecc4c191938265ce08697a0f3f2de6"
    sha256 cellar: :any,                 x86_64_linux:  "475f64f308755084f2fe987e5a25eb047a57a90a93a6974246061226df3055b9"
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
