class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  url "https://github.com/iamrohithrnair/emeraldian/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "4f05109733fcd2b1f2eb4faa2ccc824a86e3a7bdf24bf64d4bbeb18f257d4591"
  license "GPL-3.0-or-later"
  head "https://github.com/iamrohithrnair/emeraldian.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7839c72560585050ea2807cc465f991a943eb1ceb8f948a9906fb79a4b6cb347"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04fd431251670964c39d81c6894e876ede5f3d5473903bfd4a255de738a7bc5c"
    sha256 cellar: :any,                 arm64_linux:   "cdfbd3b6365742bb01ea5cf438d097f84de2310b1b38c3d9d6d394bd095bf107"
    sha256 cellar: :any,                 x86_64_linux:  "2fb18d4f70a64456e078a3ddeb5fce9f3243fbc34182cf8dd257276723149e46"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/emeraldian")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/emeraldian --version")

    assert_equal "No vaults are registered with Obsidian on this machine.\n",
      shell_output("#{bin}/emeraldian --list-vaults")
  end
end
