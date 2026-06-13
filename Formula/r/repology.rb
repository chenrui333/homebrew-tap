class Repology < Formula
  desc "Command-line interface for Repology.org"
  homepage "https://github.com/ibara/repology"
  url "https://github.com/ibara/repology/releases/download/v1.10.0/repology-1.10.0.tar.gz"
  sha256 "2d918ab0525415b5a4b2920cd2814411815b58b2d94a310eba31bf5e8a954257"
  license "ISC"
  head "https://github.com/ibara/repology.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40e0427a14e48e2bfec7e671f53f567f91d84b1e5acfd2e3b239bc6f08de9219"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc0c4e5ee51d8dcefe729fbb84ba88605554af7155a00a015ddbfe44b10b06ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0afa3d03318672d208045dffa50cce6b5b16e3094ae18855017148ef25248679"
    sha256 cellar: :any,                 arm64_linux:   "c79f6f925e9fd7fc13294c229d1ca47ba854ddd85fd84048bbdd2939e12f9611"
    sha256 cellar: :any,                 x86_64_linux:  "648ef96556ead2a5f25e367b1e227816ce9ac1c86ba2c52a7c620816d60b60dd"
  end

  depends_on "ldc" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"

    bin.install "repology"
    man1.install "repology.1"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"repology", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
