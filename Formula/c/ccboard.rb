class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "cb4687c7ddf8b060ec97c9764023426c111d01bd547a09a7c24223ea5fdaefd8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e28a21e7efb498d7533abf268fadfa1ccacd5366ee062691cb078f5a20bd40a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76ed566c015fcdd989c4bfd6c70b86dcde1c06b9a7538092ac0c68140f0b5755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "182820daad87bd3dc10c1f90920e8d849c2fef51dfa55cc5468737b7c84fc32d"
    sha256 cellar: :any,                 arm64_linux:   "537de4e37c07734bbd40b1acd90b6c11eca0615eba386bf0b809711d600703d0"
    sha256 cellar: :any,                 x86_64_linux:  "04e0a15ba377dda80714986d44f4fb7361f2d2ed79571ba3a89e224b54c60b27"
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
