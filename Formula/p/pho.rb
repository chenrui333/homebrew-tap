class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "ad5e09425de84b8ee3c4c64b3b4272c0816c59422e238b4d6263672f18174967"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "845451df3948fdb87aed58c8a111081989c2407dd3679ebb278049fb230377aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82031473047c43149bf97b98240f541488d253c27d267f8fd723131afad48b8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82031473047c43149bf97b98240f541488d253c27d267f8fd723131afad48b8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2077753d79824b5ca39a920e53fcd0f15762bedf433eaee3d0b0763a122e30ec"
    sha256 cellar: :any,                 x86_64_linux:  "ce24397b50af4252618f42e0a6021f999d4dbb4243185997ef95b62f7e261201"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/pho"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"pho", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
