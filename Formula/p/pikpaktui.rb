class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.58.tar.gz"
  sha256 "51b3e1dcb6881c5e44edd5a266dc762835a371fbe87447b1945fbbd8505dc7a2"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ab888fce695c6f1d8785e49d8b78529166759999717e8d6e7c3d2879ef72fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4129b84af75ecff8fa3cd1ccd2ccf0000ac5cf3a8d670ded07ad390d041cedfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50b8780b0c97cee1cf9ab7901e4937814d854c5042fae45461f837bdfb0c28d4"
    sha256 cellar: :any,                 arm64_linux:   "decd99d7ca1c9c8c38ea62b93e02a1cc8097489a68eaad4258f5db8cba26c15b"
    sha256 cellar: :any,                 x86_64_linux:  "4172fc3427c03354e02253f35ac7433456b8ba34630e6dccd5360cc23bff283a"
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
