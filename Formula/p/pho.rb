class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "5b74148de545fbd041addc1ac875ecfeb7e7cb8aef2372704c2abc7e2bd6a099"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c1d9d13d797a99ba9b3046fc6737d7b8d617a5155be5932a12e78bbbbdf3905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c1d9d13d797a99ba9b3046fc6737d7b8d617a5155be5932a12e78bbbbdf3905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e765fd6e2c99bd8ef56e89ea5a005a1973860dc4fbe4aa8fd68c584c7a9509bb"
    sha256 cellar: :any,                 x86_64_linux:  "23cb89ea4221e0658667882604c216acc65abf05db4a0be7c587349775628dca"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pho"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"pho", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
