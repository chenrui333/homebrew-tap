class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.55.tar.gz"
  sha256 "fa84351e3c6759dbce5965d7d6bd8900a925651997ce43497e59b910cc201720"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77dbd07c3d20d44fff04cf82a6adf7eb38c04895b552080a5416c06301084d70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1eb3723105df826f38c2945ddd3c0be3b03ecafc0825735237dcd10c5af3698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abe7e1f8369fd986a0d7e2b59de2fd9eade979cd318cd37700a1598093c678c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c445f88e5f2c1034934dbe987933a2a89841a76a21d5e2ee0a3b926ae9270d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb5e7abdb26f2c350fd35d88c8457d4f97ff936fb77bf4ab993262ec83916f04"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pikpaktui", "completions", "zsh", shells: [:zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pikpaktui --version")
    assert_match "#compdef pikpaktui", shell_output("#{bin}/pikpaktui completions zsh")

    output = shell_output("#{bin}/pikpaktui ls / 2>&1", 1)
    assert_match "Run `pikpaktui` (TUI) to login first", output
  end
end
