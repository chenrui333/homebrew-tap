class Sakimori < Formula
  desc "Cross-platform supply-chain guard for package registries"
  homepage "https://github.com/bokuweb/sakimori"
  url "https://github.com/bokuweb/sakimori/archive/refs/tags/v0.34.4.tar.gz"
  sha256 "cb00e2fc32b58ba7c292b6c746928afd303a184f7efccbca278a83a6eed7c4df"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/bokuweb/sakimori.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28a244f717721ccecde3dd03e6b4050eb3c9c6b01d8ee4b6c157ebb1e2bbf48e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "025aa25499df87c62fee8b8e609d8d57ba3a8f27bb07d92cb7e697a4ced3f021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4faf93938eaa216e5041f479abbfbbf84a57f761acb45ff85a70788e063fc890"
    sha256 cellar: :any,                 arm64_linux:   "547e39a431504e0595e740fd170bd2cb6aa10f16dc937df8654e972ad9c02531"
    sha256 cellar: :any,                 x86_64_linux:  "3c89adaca5e3746bff12bccccb55cf7cd8a18a2dced752ff73fb58a1e148643f"
  end

  depends_on "rust" => :build

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
