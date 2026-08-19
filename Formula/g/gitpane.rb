class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "4aa6e29d8b7f8513a312338fbe9c66360b89a3cd98730f6caa431616a230027b"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f707c19a69ad9dfe57aae3681930f7a6062fe8b8d51e39eb40c3a38cf0392b9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f2803f0275fbe99dc6d48160b69327f96b1104632d3cd8480038801021e3cb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ade7080253ebca5f0f2ea45862e76daffabdd444339c1c7153db6584294d8c"
    sha256 cellar: :any,                 arm64_linux:   "c99b569cbd51f91c566ac6dd3a0b70ac2fb9bda2330b70f6cc927cb88957c403"
    sha256 cellar: :any,                 x86_64_linux:  "9e495bffde4160f05f64c761c7d1eab435676c87cd70d034a06f06e6c1176134"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
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
