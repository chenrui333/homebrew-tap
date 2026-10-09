class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.60.tar.gz"
  sha256 "5b80f59eb5a6a1ed8ecb0bf36f7e344fb4caa733aeba0c4a2fe1b055bcde3879"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "519bcd9f43a9f4fe5cc5cef517427821d496d6b409ccb84693bf141579133776"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2222070f02392fe42c844032605c01105f115ef87c4cfd449596694a84d59029"
    sha256 cellar: :any,                 arm64_linux:   "d7bedfc656f43c3c9166cad0802b66eaf61f0e0fb8bad9b3d0c4b465e14d9551"
    sha256 cellar: :any,                 x86_64_linux:  "c402c96f35e1ddfb4985d275c432bb68776d48cde6469616df121f0cdc1e3ccf"
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
