class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.13.tar.gz"
  sha256 "7e5baf4473e2bbe5c8dc29a4a4ad6bf8b9764ba5582affeda5a3de8257d992a6"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "847f0e649c6daf5379de2487b106e0e168500ee1f5724131344d9598e34dddaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0da86763286c875099bcb559e0f816b55eae256116c2f2a93153cac7725d3eba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a364a7cb202f0e5dd5dd3b48652010ca10d54cc97613efea2a425ecbbd7b04b"
    sha256 cellar: :any,                 arm64_linux:   "c536ac88978935621bbd9746bdc040b977beecdad34d0e7c9eead8ca70769e8b"
    sha256 cellar: :any,                 x86_64_linux:  "fa9315847a9f9c898ca9326fcca06d3135cb443e7235f73451bfc8e665e9624e"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"gitpane", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
