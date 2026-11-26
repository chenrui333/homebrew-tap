class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.68.tar.gz"
  sha256 "c037254772cad60aadb470069abac3683b2a0f14b60d6052170ab1c1a2313153"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "671f28234847ea6680f426938c8398e3f58bc3c32ca2795f29a5742c8a38f776"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cfc5f0b9ab28158419d10fa2034718408bed997299074bd13f90d3546b0aeca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b7ef435a9039cad49de4de942d29dfb0ec40358396b65f08ed2c2d75226164"
    sha256 cellar: :any,                 arm64_linux:   "b3b1fabd6fe1f84c2a9d522f5a9fa1f81613b721aeaf87e1d9f4dce924e7e9d0"
    sha256 cellar: :any,                 x86_64_linux:  "96a240dd5ee7656fae5e5c89d248a8480aee1c96b77be8a7a2a05dce61a0ab0b"
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
