class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6d4b9c8a3ed29e5c1e62182ffd09a4c143b6b651f7bdd5a888269d2d605f301c"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e53e70f2f57e96efea46e96a7c314bfaa32e0c4c2be10285638e184bb1cee54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e161ecf411e0706348d5ceb33836f3f20b8af4f11ea89f24042ab77f9f76ed3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe920b73822094d3fe7de11b8a4748840ec7571f14dd70d28c5573a830f2add4"
    sha256 cellar: :any,                 arm64_linux:   "1d67cdeef7d55b6a4e84f03ee81435606ad25cac6316be1066bee07b573bbfb8"
    sha256 cellar: :any,                 x86_64_linux:  "c7f0c231126e380dde742d14c94e2c8251e65e4bdb83149101a99df67ddea1fa"
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
