class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.63.tar.gz"
  sha256 "d73a3ea09d46a2c5b852b50dd3649567cbad2ed8c9332adcef115bb93dd13506"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2234ea3e74e432f307e95c981a714770df58b78ea572715a9db1ebb6a7f62e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b77ff13cc846f25b3ed7042fdd0d4d9065b48bc95cbd8b8c18a90d5b25ffe81e"
    sha256 cellar: :any,                 arm64_linux:   "65749c988d133c196d43a8db2baabefc60ee7c2b6255ea93f07bf19963b545b7"
    sha256 cellar: :any,                 x86_64_linux:  "4e231cd4e8054099ff1920f5c793c397d879ea2a59f395c8938775364dd70762"
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
