class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "dd6dbf9afb6aee84e0523ecd5635abd7f2b77cda4dc07e1e480714ef7b26adad"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79afeaef53b93f56887f0194989813ccb4fe5bb7e144e7d3a9b7354d08f58bf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79afeaef53b93f56887f0194989813ccb4fe5bb7e144e7d3a9b7354d08f58bf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79afeaef53b93f56887f0194989813ccb4fe5bb7e144e7d3a9b7354d08f58bf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52d916e5b9fbfaa87abbffac80f62f6206e24a3f5531b9a14ac598a1de449699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d47b2600d186aff09c1a000ca67717ff2b9808e9e64f300bc5e89b8f008509"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")
  end
end
