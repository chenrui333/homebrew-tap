class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.56.tar.gz"
  sha256 "b6d99ed940dcba17a155f0404c8574eefa3a20dda4019d9cd504d05bacb2463c"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a40a515e22939a3bd6b7d298394c93795ff6ab3948d6342c98e38c55ab7f528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f45c5de73a0be88021a860da099bd45982b2369850012f06ea2caba0381dfe65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2deb48416f851de7b3677abf85f2d473ac4c0cf7025a01aa5528e2ca4af832c4"
    sha256 cellar: :any,                 arm64_linux:   "5536e9424dc2a438848a2751a5eba9a45cf98e7e953dfdbeca0f5120101f1f58"
    sha256 cellar: :any,                 x86_64_linux:  "4d48d42a401d7aa36d0e9db813ab06ab81130db2bb2cf6339737deb0379910cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pikpaktui", "completions", "zsh", shells: [:zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pikpaktui --version")

    output = shell_output("#{bin}/pikpaktui ls / 2>&1", 1)
    assert_match "Run `pikpaktui` (TUI) to login first", output
  end
end
