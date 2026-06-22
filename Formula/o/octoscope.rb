class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "9cbe3661b629a9013f117a5dc8850990d8fbe1826900cfc7441f4c035c1e6f24"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd6abf3c1ccc9a0b47c5ed57906cc6ad271b463376ac8f6680fd7d30a280ccfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd6abf3c1ccc9a0b47c5ed57906cc6ad271b463376ac8f6680fd7d30a280ccfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd6abf3c1ccc9a0b47c5ed57906cc6ad271b463376ac8f6680fd7d30a280ccfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ece601ffd672e501c9b0cda882e7e64986fc37b5739f9e28a64aa3f5731e93de"
    sha256 cellar: :any,                 x86_64_linux:  "0d0f6388cdcb24429ad336bb1ea1d249ea3e21ace0858bb7a84786d624694511"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
