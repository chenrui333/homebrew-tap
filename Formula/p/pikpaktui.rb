class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.66.tar.gz"
  sha256 "9e5e14758247732705f505c8881784474b3540a20674717f1a848ba3f6652363"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "00a3def5b3779ca7f5955e60d4e126d3937278a0b16ad040163fc6ae9059371d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "396deba38c70956b7e1a8bd1f54234f2fe7b1d3d93f78791d3312b26f31f4a66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aba56c9001b2f113c0a684acaeffd10f5c07b4dd636daa255f645dacb4223ed"
    sha256 cellar: :any,                 arm64_linux:   "b7e29c6bc1f9c387a2fdf152149fe263fb3194dc45157758d9a5e3166d350444"
    sha256 cellar: :any,                 x86_64_linux:  "cbed4791db6b98999975d24154f607c08afefeea548622d1643490080f22ecff"
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
