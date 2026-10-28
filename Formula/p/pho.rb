class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "9a3adf47c96123ed90c168264f313a6c03183df5648aefbdc9f433e8e1b74794"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f133d255d325d871e3dd613cb2853fb10b81b5cfa2435e364f0d1477a9daae89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f133d255d325d871e3dd613cb2853fb10b81b5cfa2435e364f0d1477a9daae89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "552f321708ac0ef4175a8191642e997a9cdb3b179e5e0ae3ff25a12e04d1290f"
    sha256 cellar: :any,                 x86_64_linux:  "a4249e20f70caa091695b88c1708e86177ba1036348bb81b41f2900bf8da0f5f"
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
