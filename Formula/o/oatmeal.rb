class Oatmeal < Formula
  desc "TUI to chat with large language models"
  homepage "https://github.com/dustinblackman/oatmeal"
  url "https://github.com/dustinblackman/oatmeal/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "dee11f69eabc94adeb58edc5ecf5b51556bd4dec3a6a3d66c3a5e603aa8a0256"
  license "MIT"
  head "https://github.com/dustinblackman/oatmeal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2a972aa9e987bdfbc9be55b2a6719f3224276feeb9dec85f7999adab96c1787"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c27d86cd2dfb43b6a9513e51da145ab4c9e7185da3da872f9fc2b50ddd13a8e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2029a5faa8ca7ee8cc9de8ea3d8014bde83f4185e946c9329997d5a6a93a389b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43013c19bae88ffe2557f5c0cbdd2a7cf32ea4356f2091caaf8382bb36e0a6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2166e10f4be1a059455d1158c53e297bc0ec4801b426396b9f97708189b39d2d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "update", "-p", "time"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"oatmeal", "completions", "--shell")
    (man1/"oatmeal.1").write Utils.safe_popen_read(bin/"oatmeal", "manpages")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oatmeal --version")
    output = shell_output("#{bin}/oatmeal config default")
    assert_match "# The initial backend hosting a model to connect to", output
  end
end
