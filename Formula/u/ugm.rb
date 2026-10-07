class Ugm < Formula
  desc "TUI to view information about UNIX users and groups"
  homepage "https://github.com/ariasmn/ugm"
  url "https://github.com/ariasmn/ugm/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "a627102861486093d2a65249a5ca7d0fb6e16ae0844716713a37b34fe79a9169"
  license "MIT"
  head "https://github.com/ariasmn/ugm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e6a67e67e23e2201fcfd2970e28fb68a1a975a99ef7746124b93d4335faef962"
    sha256 cellar: :any,                 x86_64_linux: "ac3788e4245770acd6731691f9924d9398345f0bf08f218d9f30acddc2587225"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("script -q -c '#{bin}/ugm' /dev/null", "q", 0)
    assert_match(/\d+ items/, output)
  end
end
