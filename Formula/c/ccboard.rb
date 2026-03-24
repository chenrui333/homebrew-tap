class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "232f17f9cd168246895db570fc1660d17ce7fdb62365e276de83a4ea5dc51ddc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce886289cb73a2692813aa2369849dfbf785fb8cdf251eee4d068c4a7074400d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33a7379cabc5f51ae231d2638aa364d0379dea31819892bdb2c8f7c90cf9b045"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8c56aa8b5ff5917f070ff4f8d4052843c0a9f85bfe36ed12fc63f7cd2185c36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "645a32e97b09c36e504b2da70f9b03be3d9a60339c485c55f637e9f995c320bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b231d2f473823d5b89c5355e26ea91b92da73f910cb0d65c8e3a53916fc40f58"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ccboard")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccboard --version")

    claude_home = testpath/".claude"
    claude_home.mkpath
    ENV["CCBOARD_CLAUDE_HOME"] = claude_home

    output = shell_output("#{bin}/ccboard stats")
    assert_match "Sessions indexed:", output
  end
end
