class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "9358a25c00744cf6010afd3520faec759ba70eca92df8425c82865de7c2c2b24"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0660957f115f2765fe771b338ea08647c812160d7597fd20e851d1069d7929e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0660957f115f2765fe771b338ea08647c812160d7597fd20e851d1069d7929e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0660957f115f2765fe771b338ea08647c812160d7597fd20e851d1069d7929e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13b0361c25ae2c1b20719db6a8007f8973295e2ea9cbfef1781f701be06e2b73"
    sha256 cellar: :any,                 x86_64_linux:  "010b4e7423e9887f5b2d8cb7c2fd26099b722c4e03e75996370ce35c781b50e3"
  end

  depends_on "go" => :build

  def install
    cd "server" do
      ldflags = %W[
        -s -w
        -X main.version=#{version}
        -X main.commit=#{tap.user}
        -X main.date=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cmd/multica"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multica version")
  end
end
