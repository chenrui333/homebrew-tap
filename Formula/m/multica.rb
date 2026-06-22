class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.27.tar.gz"
  sha256 "f8d903b167f44806673d0e4824a27dd36dc2447ec6db4018eb95b7972a02af3f"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "514a50dac5f1b25a28bbaa861b058094245c9fec8952962ef163e4c2ee9ebc62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "514a50dac5f1b25a28bbaa861b058094245c9fec8952962ef163e4c2ee9ebc62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "514a50dac5f1b25a28bbaa861b058094245c9fec8952962ef163e4c2ee9ebc62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc35ea4fa4da40971b47b4f12df8292c1ab368cedfaabd787db18e7fb98d136a"
    sha256 cellar: :any,                 x86_64_linux:  "903e5bd17ec62975e87021c8d5267fcfe68545db8687205eb69a30eccaf2aa02"
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
