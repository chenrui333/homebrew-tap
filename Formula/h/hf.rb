# framework: clap
class Hf < Formula
  desc "Cross-platform hidden file library and utility"
  homepage "https://sorairolake.github.io/hf/book/index.html"
  url "https://github.com/sorairolake/hf/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a7bf875dedd673fba5bd69418ca197eeaa7c8772ee57601bbbc01bd9e0d3bad1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f31114c79c6fc34bea7009a7486c38d84c2077e950e87b5968fdef414e324a5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e568fa38826638c9bd5973298f300b5e856dbc9a39c7c70e11c5b34bbe582786"
    sha256 cellar: :any,                 arm64_linux:   "e29e8017f45487b859cb2617b7c88dc5f26f2ca41e42ebe418267c2a2bf6c662"
    sha256 cellar: :any,                 x86_64_linux:  "c486ef7c4c04ff547f928dfbe4a5fdb1a1a572b747140eb5267b51c9d3e9be63"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hf --version")

    (testpath/"testfile.txt").write "test"

    output = shell_output("#{bin}/hf hide -f testfile.txt")
    assert_match "[INFO] testfile.txt has been hidden", output
    assert_path_exists testpath/".testfile.txt"

    output = shell_output("#{bin}/hf show -f .testfile.txt")
    assert_match "[INFO] .testfile.txt has been shown", output
    assert_path_exists testpath/"testfile.txt"
  end
end
