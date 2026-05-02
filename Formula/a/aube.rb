class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "b6287ab4c1a8408f9fdbebd2619c4ded5383ed358a472c07addf4cb7a6f8504b"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d652f26d2c93b6fafc35f2967ef8e0308f15f2a0a004dc23a1de08bd7407ef1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3241bbfde122211d4dc5e6a10bce6c49e28fd116956c09520613ac7cdab0d88b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ded45a63df9b13c36f16f2c0fed2165297efcba05a6bf9a0c70bb855d00787"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bba87ac56fbca2dbb9b4282555a18addb4a1c46d8528a854e84075d714408d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eceeb65c1aacb8ad06f8f9088417356782d5983dda611724546731ab95a26a3"
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
