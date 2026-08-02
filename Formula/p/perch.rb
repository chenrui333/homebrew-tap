class Perch < Formula
  desc "Terminal social client for Mastodon and Bluesky"
  homepage "https://perch.ricardodantas.me/"
  url "https://github.com/ricardodantas/perch/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "8e1b2d6dfbd324485996ab9b3c35b035fd0443e8d5608d447b947c53364ff48f"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "045b9f89fe9817a382f38b1c4355169519d43d0c124474e5922a061737e1a6f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3895c0aa0628bb36aebc98932c628e319980289e2fff4bc8f40bd26dee5480cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b84c820a1c0b38bfbe0c2894b425eebe99548b3471f0fa9876407931d1dfe432"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c27b9a8b2060de7887ee61a68996df77c6d8966bb12780ef1e7232724e48d128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d86019c719b1785cc52b54dfe26238c8fb80fce18df2f69afb3b5fb2f4472361"
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
