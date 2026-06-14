class Gecit < Formula
  desc "DPI bypass tool using fake TLS ClientHello packets"
  homepage "https://github.com/boratanrikulu/gecit"
  url "https://github.com/boratanrikulu/gecit/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "09f5dcdddcab4bab87c5e704f837060f41a8f99ba36959576e9ae16f530eae3b"
  license "GPL-3.0-only"
  head "https://github.com/boratanrikulu/gecit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c87cbfa2add33c76d85a5f53ae539869b5665757c476eca41ef913064240caae"
    sha256 cellar: :any,                 x86_64_linux: "2127c897c6c4ecb2e0c7a609ecfbc2c44b38eb52fd087a438ec8d5441ffa9035"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gecit"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"gecit", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
