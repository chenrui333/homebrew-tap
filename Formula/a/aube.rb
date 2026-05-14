class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "f2169e0945d05db6491712e35005e26b460efd339b6bb573a7c74cc0d3c9c832"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90f3a9fb44de9381fa7085090c44151a490d82c343da4818bcbd4282b2171d8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11204848819932e6fe36eefc269ef7b6f2d93c9925a9f5f8edc6cbcf2c5a363d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "766ce362572baa7a1c3901f049476c6e31726167942ff8e1bd039e39fa38de5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a5f3b09cda51e49c0ed32e0110d2c4d3c04d11205ec949a960f59597aca6cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ecf77fe96bfca31e6956465561e49d307b67319f5428a6c073d3d9c58108970"
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
