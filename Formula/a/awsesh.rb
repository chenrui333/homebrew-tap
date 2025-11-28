class Awsesh < Formula
  desc "TUI for AWS SSO session management"
  homepage "https://github.com/elva-labs/awsesh"
  url "https://github.com/elva-labs/awsesh/archive/refs/tags/v.0.1.11.tar.gz"
  sha256 "cad8808851902bde88c766b11178e93a444fa27ecebb4a6bf11f334b099ba90a"
  license "MIT"
  head "https://github.com/elva-labs/awsesh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87086541027d05c6a72a5d6bbc425446c46c7ebb8190d9812e23cbaac1471072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87086541027d05c6a72a5d6bbc425446c46c7ebb8190d9812e23cbaac1471072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87086541027d05c6a72a5d6bbc425446c46c7ebb8190d9812e23cbaac1471072"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d8d0e214c4914cc89cbae9b13a038433154e6b12f15306f1d1005c67a45ca0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40dc8ad43b322ffd9e6929de3af0c0eaaf436c86d80ef16384ae226312b4fc8f"
  end

  depends_on "go" => :build

  def install
    # NOTE, the official binary should be sesh, but it would clash with https://github.com/joshmedeski/sesh
    # see discussions in https://github.com/elva-labs/awsesh/issues/34
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awsesh --version")
    assert_match "Error: Could not determine the last used SSO profile", shell_output("#{bin}/awsesh --browser")
  end
end
