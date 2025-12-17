class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "cb5a312ffeefb0ec2e163889f62302ef3a42dfcf09f64189d37391877fc707ae"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0bf29f645d477cc318129055afc0c6f52ea3f91f007eb657e8dcd1fa9ab9436"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b13fdea0dc0644e7554f59e6a6825e53217df926cbaf4449c926b5f25150b15b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ec9b28a7e370d306f85330a4f167dcaa8e76892987c90890bfd13990fc4faba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6637e99dddac97ec72cd8db73f969b0108cf6dfeab5b904fd5556b45f7fbe9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ee7d45c73c9e2d15e405d47f3bbb2b6df44e1935e53a1e3bdd2e3681684280"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
