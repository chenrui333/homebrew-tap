class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "36cee64ebe3fa1a905b4e82ad0c87b6f5dd018ffb444cfd4db0402ffa9d9efb3"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db40d527cc6e97b8d9cbee3b739e5e7f0e4e22fcf3341ec92628c497d7d048b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2df85ca76bffbc9ee0e41f388c53dd06dadaacd6525c6e6904b9782150ce8b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef936323faa48e9a63c2ce40be516e25ddb5fdf1ab6d5e04f9fa7d869775f0e8"
    sha256 cellar: :any,                 arm64_linux:   "974b41d63ea52b319f178cee32537f151734bf15f5f5606fbf697b17c320d83f"
    sha256 cellar: :any,                 x86_64_linux:  "15badb5aa67cba9e3c012d72c28368848d7ec7071459714ab0e339a2b5b667af"
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
