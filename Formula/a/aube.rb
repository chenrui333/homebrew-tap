class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "1dd9a4028ec5fc67f131d8c4f7174bb8a12df7e861fcd16e7690fc7c18fffe78"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb8b5e924a5f40b5388b14efb68c27a84d3e3503989f30ed7c7e354985be455a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe57909346c0e94a7e41ba7c2d8c74d1b0a8afe72ad3a9f27d3f413059ee713b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bb1c142571f7dc45e1aee4a96dcc7dc947fc2c3d3d10c7020cd9198e870d333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfec2549e6155ef0f4a32a24f545fc22d51840f0c34403ac9979083bf7d0d5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c7f2d43e594917c6386d92257e82bc255ffd042066bb8d056d77edfd385f5b"
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
