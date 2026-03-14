class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.54.tar.gz"
  sha256 "a8e4d47827e0a6c3a1711ea19292010d79ec75306c45fdd6da76200570fff9ab"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f95894dca8e515f670c8c761e4a40c05989eb31835bee3e5ebca7caa3d0197ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc6fb4017ef3f8fd367bbb3a492e81b525e9ae77b5dea2677059ac7e3aaa01b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2deda96ccfdfc2f80c12223bc50f19e6e836bdad3b2cc2eb773d382efcd257af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "973166130f10c20758b961a744c3628886437af0eab69de34de07cf6c268ae95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e3c374580df06f73f668b167f44e2a81b4122a4cc69dcf130f9e40e2b1f8126"
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
