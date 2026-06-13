class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.56.tar.gz"
  sha256 "b6d99ed940dcba17a155f0404c8574eefa3a20dda4019d9cd504d05bacb2463c"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8b50bae80c8a1f84d38d88163e075cb4505237809e0796d499eaf8107938425"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16421e202655963107fdf9ee97f1eb240947e8671ce326362ffe5a1aefe6f01f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d7e90c424b5dd42b436984f3e4532db846ea973b12cbba2827033390f5a3a81"
    sha256 cellar: :any,                 arm64_linux:   "e3289228616f68670dfde9bc03a56e7053da1dbdbdac5fe535909a5b5c5acd4a"
    sha256 cellar: :any,                 x86_64_linux:  "65a54661e1b19fe413c9ee386ea8742a8cd1b1d6d78a3cfafee6a793c7177e54"
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
