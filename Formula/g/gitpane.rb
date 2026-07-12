class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5999d1cf93334938b6ff961ac04ae8f8a5fc42ece31b77da48c4067fca23ac6f"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a94993055cb3eb270f70ec27ee8d55d3fa6da590a46bb34886a65ce893fe8de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d161feb5b07404ccbe3f07df33ccb2f41f6f40539c33ca838436cf834bdf9fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dba0d2a6f104bc69af891e769b002c3d3913c3a644e3b54185a80f0eca58dfa"
    sha256 cellar: :any,                 arm64_linux:   "fc1270d3c76c24b27cdc8594fe2a4fa9984f727f34ad85cb439cfde04f06e90a"
    sha256 cellar: :any,                 x86_64_linux:  "c6f309c4a109431f5821c3e524c69bfc519b3611a94aed67cf4c98773ffa9bdf"
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
