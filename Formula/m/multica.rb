class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.38.tar.gz"
  sha256 "19dc83ecd2e5c502174c268d7538a583ae302348b2f7949604b4ed5652ae474d"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef0f996c1305647df0766e6aaa9ea11960143b264893391fe7334cfbeb05b473"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef0f996c1305647df0766e6aaa9ea11960143b264893391fe7334cfbeb05b473"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef0f996c1305647df0766e6aaa9ea11960143b264893391fe7334cfbeb05b473"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b08da9a9ee701c437c4af283ea2037e6661dea59c513aafcbbe75220bca7b2a"
    sha256 cellar: :any,                 x86_64_linux:  "c7c5862c890545f8c9da389e1d34f5e12f2e238462d0f74960142ee1fd6a42b9"
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
