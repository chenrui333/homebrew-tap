class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.58.tar.gz"
  sha256 "51b3e1dcb6881c5e44edd5a266dc762835a371fbe87447b1945fbbd8505dc7a2"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98346bf3e80f4fcdff09401e51493b3dfd36b5a5b75623cccfa9857eb9c60a89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0687198a8c9ddeb2989e98e627c3fb9564eb97503804e414b29cd477642ea2cc"
    sha256 cellar: :any,                 arm64_linux:   "dc102eaf3346d05e0e6a6f588512db7c1651dbd9c7de8109cfbb77aea4d81fd2"
    sha256 cellar: :any,                 x86_64_linux:  "8cd45d7145f37092653dab4a1b9070537c69e2637c8fa7d096a2caed1d6236ee"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pikpaktui", "completions", "zsh", shells: [:zsh])
  end

  test do
    # Disable the background GitHub release check (documented `update_check` setting)
    (testpath/".config/pikpaktui/config.toml").write <<~TOML
      update_check = "off"
    TOML

    assert_match version.to_s, shell_output("#{bin}/pikpaktui --version")

    output = shell_output("#{bin}/pikpaktui ls / 2>&1", 1)
    assert_match "Run `pikpaktui` (TUI) to login first", output
  end
end
