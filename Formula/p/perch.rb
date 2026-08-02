class Perch < Formula
  desc "Terminal social client for Mastodon and Bluesky"
  homepage "https://perch.ricardodantas.me/"
  url "https://github.com/ricardodantas/perch/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "8e1b2d6dfbd324485996ab9b3c35b035fd0443e8d5608d447b947c53364ff48f"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0656c35d2cebbdd8051d24cb7ef7aef87db1e8d93146fa589acee56d25baf716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e524dd46d9da3f5e56968907e2f2f5092605713d2cedf897639d33363160dd8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96d7bbe9b6a32da314c22b455a7fc9d337fe178123b9d1b9e7b90f429f036056"
    sha256 cellar: :any,                 arm64_linux:   "cc989fdbac0ad838dae9a3e25112801b179cdff80ac601041720900e403414de"
    sha256 cellar: :any,                 x86_64_linux:  "ca1f2b183095707380f09d451317aa0b66841ac48cebc97c75c75a493236f199"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("HOME=#{testpath} #{bin}/perch --version")
    assert_match "No accounts configured.", shell_output("HOME=#{testpath} #{bin}/perch accounts")
  end
end
