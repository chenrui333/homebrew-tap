class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "fd826586e43d33ce90933285f85d1d922573dfe2d01b705b6ae16f8a1a8282b3"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f26555bc09911e9a2c010552dd02ed83a848f809ca490cae8807304f78f98716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc33ad4140278d309ff3ffd3559def538df2ed948813cebe7e5f9412cbf5e739"
    sha256 cellar: :any,                 arm64_linux:   "c9abe1de2dd9a24c5d4c6c36f4d50fd8f5e97e132dc90501ba15e91594078b2b"
    sha256 cellar: :any,                 x86_64_linux:  "1cd84a4b911fd42bbd0c8c1fe83b9da7265bc6746e172c2f6b427b09c8a25dbc"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
