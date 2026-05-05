class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "8b34ab14c896c37fb7ad830d7929543b4f1c9d949f745d7ee78a4d90a631c20b"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "deab923dbfc5161247b14b46463369473cae0babec00ade30d2b14a5a0269da6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f20e751956e20c17df3aa89766025a0844f44bbb3e2c7f92ecdac31ba74a0f88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eea95eabf3470bfcaa2a7231f6e8f40b6a9cd006b1e47e2d5d295a263d187127"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "430d685d4e845bc4794a0fddb79bf2d7abcec79d78c0a6dc46f627a1c7a25a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d709b5bc29f19e333d94db892d259c607e2a8bb25aa12484834aadd1bcd8731c"
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
