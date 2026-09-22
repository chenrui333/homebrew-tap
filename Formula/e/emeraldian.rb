class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  url "https://github.com/iamrohithrnair/emeraldian/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "23451f2d154df4fc6f6996115e75b5b34160975bde01ac28e4ccd112bcbaf41e"
  license "GPL-3.0-or-later"
  head "https://github.com/iamrohithrnair/emeraldian.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9368cbd0b72910e1a191929be325eca346c0c01de03ff2c4983787ce869aafdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5afbe1a8ec2e00e8cf4b01560943f690d883cd32efef8cecd921f94f1d85c88"
    sha256 cellar: :any,                 arm64_linux:   "4bd1c3912d37e3258d07da378a88a2661e241917abd8ebea051be093c7816826"
    sha256 cellar: :any,                 x86_64_linux:  "ea6061c261e4ba5166dde9ad8109d325cdf73d2a20f1f21990f6e1ea69f609e3"
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
