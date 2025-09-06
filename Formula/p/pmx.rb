class Pmx < Formula
  desc "Manage and switch between AI agent profiles across different platforms"
  homepage "https://github.com/NishantJoshi00/pmx"
  url "https://github.com/NishantJoshi00/pmx/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "14bc6207dc78cf96831feee9ee3ddc712084c92350213500c4320383544a5286"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pmx", "completion", shells: [:zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pmx --version")
    output = shell_output("#{bin}/pmx profile list")
    assert_match "No profiles found", output
  end
end
