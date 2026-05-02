class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "b6287ab4c1a8408f9fdbebd2619c4ded5383ed358a472c07addf4cb7a6f8504b"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3116f929b5f1cba40c5a9e33f8c4d4ea02f4e93afc7eb72346a715df881208e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2605a0b05ffd13e7fbdea8999c1c82b879abe7055703e13d98775f5d5c1baf36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c41309fc06cdde788479739e0317448bbe997cd0b213028ab95c1eeb2b2c76e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8e678def9cebcd45dcba79e9523cbb1a9d8aba32994d4189f15389cd52933b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dfe581932bbf992a8f7d02dd1403b4ce2ce657406400e7e076f9f8b8646c3a7"
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
