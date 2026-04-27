class Ugm < Formula
  desc "TUI to view information about UNIX users and groups"
  homepage "https://github.com/ariasmn/ugm"
  url "https://github.com/ariasmn/ugm/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "a627102861486093d2a65249a5ca7d0fb6e16ae0844716713a37b34fe79a9169"
  license "MIT"
  head "https://github.com/ariasmn/ugm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "540dd4874182a8dabbb527b6905c5df00f72b08e5cdba65c6bed4c1ef2420b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ea7b236a3817de3d1ea59a5fe44a1825ac2cc0e710601791483eb0e37e8fa91e"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("script -q -c '#{bin}/ugm' /dev/null", "q", 0)
    assert_match(/\d+ items/, output)
  end
end
