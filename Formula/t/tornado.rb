class Tornado < Formula
  desc "SQLite explorer with Vim key bindings"
  homepage "https://codeberg.org/ozeye/tornado"
  url "https://codeberg.org/ozeye/tornado/archive/v0.5.0.tar.gz"
  sha256 "9f7741f41e439bca5065ff044b188390e4039e81e55e0ace13798baff10aac27"
  license "MIT"
  head "https://codeberg.org/ozeye/tornado.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff70b19692c7b625a051e5508f400ccdcac1ef37e8b038ba5de1c3d2b4b55328"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff70b19692c7b625a051e5508f400ccdcac1ef37e8b038ba5de1c3d2b4b55328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "386ca1be334785f56404d60571d31e7356877d1b0c31b4b8d7bd905c24c006d7"
    sha256 cellar: :any,                 x86_64_linux:  "74649dfe9399d668a47db65f289e3ab2e79497fd5772bae120c7af961045f86a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tornado"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tornado --version")
    assert_match "flag provided but not defined", shell_output("#{bin}/tornado --invalid-option 2>&1", 2)
  end
end
