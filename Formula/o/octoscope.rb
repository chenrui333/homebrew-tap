class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "fb7c03860e95b970b35ef0c1e4d04ec3e1cf0c276b4885b9f65d278ff18df1fc"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bdb237446e2f9c58ab6492615f600c1ffbd457a5a1bd8e7a19104e2bdf68fab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bdb237446e2f9c58ab6492615f600c1ffbd457a5a1bd8e7a19104e2bdf68fab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bdb237446e2f9c58ab6492615f600c1ffbd457a5a1bd8e7a19104e2bdf68fab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb51d46cf57314a553c9d0ff52b534867de565c310e19db7e7ef7bfd8aa6433d"
    sha256 cellar: :any,                 x86_64_linux:  "6b7e8e712f064b21a49796512d378dcb8595efa899b716ab28822d11035246b4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
