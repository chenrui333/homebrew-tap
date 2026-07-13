class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v0.1.42.tar.gz"
  sha256 "acccb2757afaedd2262c5beac611f7406e72db4825f8e0b5b54195c0de6bd6a9"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14a576b7926e68b24cb4c25a805c733e7bd0c20ac464052cb3552c32e44e6dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a576b7926e68b24cb4c25a805c733e7bd0c20ac464052cb3552c32e44e6dd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14a576b7926e68b24cb4c25a805c733e7bd0c20ac464052cb3552c32e44e6dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b599508920947d24d948a8bc1afeadecef6b2ee2dff983cbcef30771cfb328e7"
    sha256 cellar: :any,                 x86_64_linux:  "54a3ffc4f6a8075d5ef5b16cfea796e047980d035f0202592cefec2cf18482ce"
  end

  depends_on "go" => :build

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
