class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.58.tar.gz"
  sha256 "51b3e1dcb6881c5e44edd5a266dc762835a371fbe87447b1945fbbd8505dc7a2"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1225239c80b6bd608bae8bd1ae3c246407722219208b95742ac0d166e7ef5e2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b62ad220053143d6aebe759dea95c54a1b78ba8b0313d1602f4b7890ca82f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e41a78c19f6a879780973d471758bde40b3b103c8fa42786dd8448ba9d60658"
    sha256 cellar: :any,                 arm64_linux:   "2d1be8c2bb980f02a58bb1baca5157f55fd5a457a6e02c99c2f56211f3f07d0b"
    sha256 cellar: :any,                 x86_64_linux:  "a8c2ad25af5eb5857c5090a0889d52f39838fc91f050fe1dcf377891802bdf5f"
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
