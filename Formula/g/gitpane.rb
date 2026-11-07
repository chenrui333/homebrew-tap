class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "a2e1959ea80b67b00b98f90d1823994d376c7471dca7efda8441904164570fc7"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab1c798cae762df71c05aa8e1378fea194a208e53ac614e1ba31c686d895ef97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e5f6b12261485663c19cb482af7684e12c94bf82454132f767e8b7f8ec005a7"
    sha256 cellar: :any,                 arm64_linux:   "c044b631036b451f5b448ceb14fb86ba14abc5c52b154fa9bcc569fb867305e3"
    sha256 cellar: :any,                 x86_64_linux:  "555ba547fef0f143254fa9acaac5d4d76fbab28f0f98d75b8d1e02dedaa352fa"
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
