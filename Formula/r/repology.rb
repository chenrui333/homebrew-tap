class Repology < Formula
  desc "Command-line interface for Repology.org"
  homepage "https://github.com/ibara/repology"
  url "https://github.com/ibara/repology/releases/download/v1.10.0/repology-1.10.0.tar.gz"
  sha256 "2d918ab0525415b5a4b2920cd2814411815b58b2d94a310eba31bf5e8a954257"
  license "ISC"
  head "https://github.com/ibara/repology.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d09aec102d5ff1f0098e244a613832c852f1e4a91549147ea2ea4cda45e7055c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cf84ed6c51c955bc7af3fd54d14b05dc4afb38e9cee764bfe7a2fda24d809c2"
    sha256 cellar: :any,                 arm64_linux:   "4532bd129d592e9c23b0e54dae1507c7588cd077f3baaa9ad7cca4aa237ef776"
    sha256 cellar: :any,                 x86_64_linux:  "b39b518db04bd4fd0fb556ceb6940874bf8337131cab70c2d3b0970e80583192"
  end

  depends_on "ldc" => :build

  deny_network_access!

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
