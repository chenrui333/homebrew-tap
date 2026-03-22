class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.55.tar.gz"
  sha256 "fa84351e3c6759dbce5965d7d6bd8900a925651997ce43497e59b910cc201720"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8160770338d0e6dad437026236ff733d6258a004cbd46a7b0775e0f385146b4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0bc25cb2042027b971aa42a796c9f0ba1e90f2c2d8ef56d6075eef92b45f601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a83498ebe9a5588748e144f5e0ac4faffa9e0ea664e9ed6a89975141c5c3bef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb4d5c025b3d64fc1a659afc4abe6310d7c98c580eac9c1e9e9b20a745810c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "644aae9764748d261f15e2a5c3a22dfaaf50f6de48e38834a123873670f34ed8"
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
