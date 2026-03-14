class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.50.tar.gz"
  sha256 "6d1e0fc28a18f15501cffa85df0afd4297e167943502a92aa006b7bae5ac900e"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

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
