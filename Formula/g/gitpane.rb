class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "48092b2dfa4fbbe330859e4fcfeacac9506d458cf81be125b64eed03d0b8e36e"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec772e1589d7e9f8d6b11f4f743229f8ecac35eca90df37de245ad56c5c6797c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92f58a88010daa6ce2bfbb139ca9a408078a51cce38fa97d530a949569750434"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ba1c2e97bd53990bca59a8bdbbec6e78a102acb540441021a5b989e26772791"
    sha256 cellar: :any,                 arm64_linux:   "adc91ab0a1a0d505769304d145fea9aa2f534df654b39f582ddb1451efb0effd"
    sha256 cellar: :any,                 x86_64_linux:  "d898154e5e93ab8323a15a398b5c8692fd5e0e528ab9946d6c1906b559c75404"
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
