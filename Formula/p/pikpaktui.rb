class Pikpaktui < Formula
  desc "TUI and CLI client for PikPak cloud storage"
  homepage "https://github.com/Bengerthelorf/pikpaktui"
  url "https://github.com/Bengerthelorf/pikpaktui/archive/refs/tags/v0.0.63.tar.gz"
  sha256 "d73a3ea09d46a2c5b852b50dd3649567cbad2ed8c9332adcef115bb93dd13506"
  license "Apache-2.0"
  head "https://github.com/Bengerthelorf/pikpaktui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7240032330c6bee5578c22ff005090b9a0df93eadf339462d30a397510c914ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d29237bff05a35255b6c262d167ddaf3ec0aee7309bbf1786c4bd137b1e76caf"
    sha256 cellar: :any,                 arm64_linux:   "c9bb9f1055fc3c2247a6bdbb3145a9ae1f832f25573e01c104c6f908367e4632"
    sha256 cellar: :any,                 x86_64_linux:  "d91f0069cb0780d906e2975346ce8846c1c5302b8113efcd3a4ff795212cb461"
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
