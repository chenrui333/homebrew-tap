class Wiremix < Formula
  desc "TUI audio mixer for PipeWire"
  homepage "https://github.com/tsowell/wiremix"
  url "https://github.com/tsowell/wiremix/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "dfb165ff664b804099c5592fd26d2b03d78e67069522bc5d3d8ef75a19505adf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tsowell/wiremix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9c410428a6c8448372120eea5e97e76a2680d35b6e61c51e337e9bf7f8862ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3480a45b59346236a1bf16b3d932e4e1d55ee9d95eae31a503cf9775741ee297"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux
  depends_on "pipewire"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib if OS.linux?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wiremix v#{version}", shell_output("#{bin}/wiremix --version")
  end
end
