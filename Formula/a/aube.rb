class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "d29ab5973143ec8867279ad771bb82ec1c2b120d2674a434faf3ae576ca45970"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01fbc5df4c60ff717b87064bad5a94c8a80d9929ef6e4ac9741ad9d5c78b5759"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8a6f7a6beffb863b1a52e0ff88c57566ae68b47d2833390fa4621cd179a6775"
    sha256 cellar: :any,                 arm64_linux:   "18672983a88f878b01f70573424bc1e166b07f107a9b597f40e27a4a05969456"
    sha256 cellar: :any,                 x86_64_linux:  "e6b42a6a8e6b534f15e94b22016db82c263cf64dfb9e1965491bd845d0bcbaaa"
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
