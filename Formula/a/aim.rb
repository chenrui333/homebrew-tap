class Aim < Formula
  desc "Command-line download/upload tool with resume"
  homepage "https://github.com/mihaigalos/aim"
  url "https://github.com/mihaigalos/aim/archive/refs/tags/1.8.8.tar.gz"
  sha256 "5500e38e48e381557847d09e42dbb093e1e402eb2c2965929cbcdae69ce9ec9e"
  license "MIT"
  head "https://github.com/mihaigalos/aim.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8de7738e8dd003d826f77e4b4485cca4efc28503e04c7d50c8b238f526cde50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e92f98a9eb349d7bd871dd6bdb51af7d8d3dc1f727e7a3f7bc3baf3a224fc150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d36a9447354ce3752c9734aa4541aa380560d6cb2748555562b621f6ca4d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "989e853737f98c4f99cd1abb23c55c5626df4bcba4e20d4f9d0e2be0e0363f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "388bdd6a6ce5c2887422741a941d094fcc332ca4a8074cf5df8e81e91e289fb0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aim --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"aim", "test", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Serving on:", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
