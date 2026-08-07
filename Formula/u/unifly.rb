class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "8a77d43614faf35e30cfb86408917e2362fbd2486f41bef0ceb9c66ec0f185be"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b80063fea09742a3d1870b08ec8ea1ebd679850418491c2bad684bb0f76bae3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4440abeaf8be528090c409ef708180635d4967eb34d7be9c191ce63492a73bdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5540ad1d9bb3000c6a1e178a2b450639f273bf7eca5a207e846a4fddeb74f8e"
    sha256 cellar: :any,                 arm64_linux:   "e4c578be69b270c20bf2d73dd8ff4b5c207c1f423dd99a7bfd74c98560522ac4"
    sha256 cellar: :any,                 x86_64_linux:  "65c5dbfa8e96a8555b0681fcb8c13f4bf09669152dbd3f20dea0f0fe29efc0a5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    (buildpath/".cargo/config.toml").delete if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/unifly")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unifly --version 2>&1")
  end
end
