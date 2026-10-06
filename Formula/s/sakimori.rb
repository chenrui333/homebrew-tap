class Sakimori < Formula
  desc "Cross-platform supply-chain guard for package registries"
  homepage "https://github.com/bokuweb/sakimori"
  url "https://github.com/bokuweb/sakimori/archive/refs/tags/v0.34.4.tar.gz"
  sha256 "cb00e2fc32b58ba7c292b6c746928afd303a184f7efccbca278a83a6eed7c4df"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/bokuweb/sakimori.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35373061f7b5c06bf625653076e8049f639fa1d0fde535b84d8146dbb6e467cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69178f3c984b2e6bcf95ab5eaff7f1688fa9636e7a2a01c5e0dd90d4ad0e6569"
    sha256 cellar: :any,                 arm64_linux:   "42969f3762c202b996bf8a5a6ca7b12124c2e0a624cbeba0def5853bc09fe566"
    sha256 cellar: :any,                 x86_64_linux:  "d2728adae334d7061abcd98770ff729aab8fd4e7072842b576308fb4db6530c9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sakimori")
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"sakimori", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
