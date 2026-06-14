class Repology < Formula
  desc "Command-line interface for Repology.org"
  homepage "https://github.com/ibara/repology"
  url "https://github.com/ibara/repology/releases/download/v1.10.0/repology-1.10.0.tar.gz"
  sha256 "2d918ab0525415b5a4b2920cd2814411815b58b2d94a310eba31bf5e8a954257"
  license "ISC"
  head "https://github.com/ibara/repology.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9ba8af3495ffddd24ae2c40f647e5958580b31784fd380bb19c5b5d5d04d7ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f88ea89a143f35b616e6684144c4f67111d9ae5485d5dfec9f396796792908aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae18839cf52301d35e2fd49bb5ba67c28555885fbe35196fcc50d26f046c62b9"
    sha256 cellar: :any,                 arm64_linux:   "583511181176a3306eda85e9c8063870109aaa59ccec68aa0358b2e6df812135"
    sha256 cellar: :any,                 x86_64_linux:  "334b2c5f6029b647ea280cc0f47736a676d0710dc6bc40c8d147edca3bf2961c"
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
