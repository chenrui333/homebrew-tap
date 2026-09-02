class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "1f2f50fc953ba88eceb5e93fd512e82cb459d835b4d4e92ed4bb094ce383d52d"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1013b6834ed19053f9194e865e56ab9cb33b4ff05faf0696d46ddb8fac5f265"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1013b6834ed19053f9194e865e56ab9cb33b4ff05faf0696d46ddb8fac5f265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1013b6834ed19053f9194e865e56ab9cb33b4ff05faf0696d46ddb8fac5f265"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3ecce8c6805c0d0f4e86f61ed603dda1c5af44c6dffc2807be61265654972f"
    sha256 cellar: :any,                 x86_64_linux:  "6aa07b53d9481d7084f0908a19e9be5ac1b5a26fc034b0b419f24ac83b8fa61e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output
  end
end
